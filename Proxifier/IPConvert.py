import ipaddress


def func_addr_transfer(str_ip_addr):
    net_addr = ipaddress.IPv4Network(str_ip_addr.strip('\n'))
    return str(net_addr.network_address) + '-' + str(net_addr.broadcast_address) + '; '


write_buffer = ['162.105.0.0/16', '202.112.7.0/24', '202.112.8.0/24', '222.29.0.0/17', '222.29.128.0/19',
                '115.27.0.0/16']
i = len(write_buffer) - 1

with open('china_ip_list.txt', 'r') as cidr_list:
    for line in cidr_list.readlines():
        if i | 0b1111110000000000 == 0b1111110000000000:
            if i != 0:
                write_buffer[-1] = write_buffer[-1].strip('; ')
                file_name = 'ip_list_' + str(i // 1024) + '.txt'
                f = open(file_name, 'w')
                f.writelines(write_buffer)
                f.close()
                write_buffer.clear()
        write_buffer.append(func_addr_transfer(line))
        i = i + 1

i = i // 1024 + 1
write_buffer[-1] = write_buffer[-1].strip('; ')
with open('ip_list_' + str(i) + '.txt', 'w') as f:
    f.writelines(write_buffer)
