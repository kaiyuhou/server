import dns.resolver

result = dns.resolver.resolve('bob.su', 'SOA')
print(dir(result))
for ipval in result:
    print(ipval.to_text())

