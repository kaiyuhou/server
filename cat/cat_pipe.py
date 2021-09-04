import requests
import urllib3
import pytesseract
import shutil
import time
import os
import subprocess
import random
from web3.auto import w3
from PIL import Image

urllib3.disable_warnings()

CAP_URL = 'https://catcoin.link/captcha.html'
SLEEP_DURATION = 0.2

# Must pip3 install pysocks first
PROXIES = {
    'http': 'socks5://localhost:8002',
    'https': 'socks5://localhost:8002'
}

HEADERS = {
    'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/90.0.4430.93 Safari/537.36',
}


def request_once(eth_addr):
    with requests.Session() as session:
        resp = session.get(CAP_URL, verify=False, proxies=PROXIES, headers=HEADERS)

        if resp.status_code != 200:
            print(resp)
            return 'None'

        with open('cap.png', 'wb') as f:
            f.write(resp.content)

        # cap_code = png_ocr()
        cap_code = png_manual()

        ref_url = f'https://catcoin.link/m?eth={eth_addr}&f=1230257&code={cap_code}'
        resp = session.get(ref_url, verify=False, proxies=PROXIES, headers=HEADERS)

        if resp.status_code != 200:
            print(resp)
            return 'None'

        if b'Please' in resp.content:
            return 'Fail'
        if b'IP' in resp.content:
            print(resp.content)
            return 'Block'

        return 'Success'


def png_ocr():
    pytesseract.pytesseract.tesseract_cmd = 'C:/Users/mikew/AppData/Local/Programs/Tesseract-OCR/tesseract.exe'
    image = Image.open('cap.png')

    image_gray = image.convert('L')
    # image_gray.show()
    image_two = image_gray.point(lambda x:255 if x > 129 else 0)
    image_two.show()
    image_two.save('cap_gray.png')

    text = pytesseract.image_to_string(image_two, lang='eng', config=f'--psm 10 -c tessedit_char_whitelist=0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz')

    print(text[:3], end=' ')
    return text[:3]


def png_manual():
    # subprocess.Popen(['explorer.exe', 'cap.png'])
    Image.open('cap.png').show()

    # I can directly see the image in pycharm
    cap = input()
    subprocess.run('taskkill /F /im Microsoft.Photos.exe', stdout=subprocess.PIPE, stderr=subprocess.PIPE)

    return cap


def pipe(start=0):
    cnt = {case: 0 for case in ['None', 'Success', 'Fail']}
    iter = 0
    while True:
        for i in range(20):
            print(f'Iter {iter}: ', end='')
            iter += 1

            addr, priv = gen_eth_addr()

            try:
                res = request_once(addr)
            except:
                print('except')
                break

            if res == 'Block':
                print('Block')
                input("Switch Proxy. Yes?")
                break

            cnt[res] += 1
            print(cnt)

            # if res != 'None':
            #     shutil.copyfile('cap_gray.png', f'train/{res}/{iter}.png')

            if res == 'Success':
                with open("addr_book.txt", "a") as f:
                    f.write(f'{addr}\t{priv}\n')

            time.sleep(SLEEP_DURATION)

            # if i >= 8:
            #     print('End of Single ')
            #     c = input("Switch Proxy. Yes? n/(Yes):")
            #     if c == 'n':
            #         continue
            #     break


def gen_eth_addr():
    account = w3.eth.account.create(os.urandom(4096))

    # print(account.address)
    # print(account.privateKey.hex())

    return account.address, account.privateKey.hex()


def manual_pipe():
    for i in range(100):
        print(f'Iter: {i}')
        print(CAP_URL)
        cap = input()
        addr, priv = gen_eth_addr()
        print(f'https://catcoin.link/m?eth={addr}&f=1230257&code={cap}')
        #input()
        with open("addr_book.txt", "a") as f:
            f.write(f'{addr}\t{priv}\n')



if __name__ == '__main__':
    # request_once('0x')
    # png_ocr()
    # gen_eth_addr()
    # manual_pipe()
    # png_manual()

    pipe(start=0)

    # https://catcoin.link/m?eth=0xBFd2a19C2AB3D48075A3c79C9c0b2e5CfcF0d2d8
    # https://catcoin.link/1230257