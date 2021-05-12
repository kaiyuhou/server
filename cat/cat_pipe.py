import requests
import urllib3
import pytesseract
import shutil
import time
import os
from web3.auto import w3
from PIL import Image

urllib3.disable_warnings()

CAP_URL = 'https://catcoin.link/captcha.html'
SLEEP_DURATION = 30

def request_once(eth_addr):
    with requests.Session() as session:
        resp = session.get(CAP_URL, verify=False)

        if resp.status_code != 200:
            print(resp)
            return 'None'

        with open('cap.png', 'wb') as f:
            f.write(resp.content)

        cap_code = png_ocr()

        ref_url = f'https://catcoin.link/m?eth={eth_addr}&f=1230257&code={cap_code}'
        resp = session.get(ref_url, verify=False)

        if resp.status_code != 200:
            print(resp)
            return 'None'

        if b'Please' in resp.content:
            return 'Fail'
        if b'IP' in resp.content:
            return 'Block'

        return 'Success'


def png_ocr():
    pytesseract.pytesseract.tesseract_cmd = 'C:/Users/mikew/AppData/Local/Programs/Tesseract-OCR/tesseract.exe'
    image = Image.open('cap.png')

    image_gray = image.convert('L')
    # image_gray.show()
    image_two = image_gray.point(lambda  x:255 if x > 129 else 0)
    image_two.show()
    image_two.save('cap_gray.png')

    text = pytesseract.image_to_string(image_two, lang='eng', config=f'--psm 10 -c tessedit_char_whitelist=0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz')

    print(text[:3], end=' ')
    return text[:3]


def pipe(start=0):
    cnt = {case: 0 for case in ['None', 'Success', 'Fail']}
    for i in range(start, start + 1000):
        print(f'Iter {i}: ', end='')
        addr, priv = gen_eth_addr()
        res = request_once(addr)

        if res == 'Block':
            print('Block')
            return

        cnt[res] += 1
        print(cnt)

        if res != 'None':
            shutil.copyfile('cap_gray.png', f'train/{res}/{i}.png')

        if res == 'Success':
            with open("addr_book.txt", "a") as f:
                f.write(f'{addr}\t{priv}\n')

        time.sleep(SLEEP_DURATION)


def gen_eth_addr():
    account = w3.eth.account.create(os.urandom(4096))

    # print(account.address)
    # print(account.privateKey.hex())

    return account.address, account.privateKey.hex()


if __name__ == '__main__':
    # request_once('0x')
    # png_ocr()
    # gen_eth_addr()
    pipe(start=11)