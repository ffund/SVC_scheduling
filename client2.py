#!/usr/bin/python           # This is client.py file

import socket,sys

s = socket.socket()
#host = socket.gethostname()
host = sys.argv[1]
port = 10002

s.connect((host, port))

layerNo = 2

round = [-1,-1]
while True:

    message = s.recv(9)
    if message == "finished!":
        break
    size = int(message.split(" ")[0])
    layer = int(message.split(" ")[1])

    name = s.recv(13)
    segmentNo = 10*int(name[7]) + int(name[8])
    if segmentNo == 0:
        round[layer] += 1

    if segmentNo + round[layer]*30 < 10:
        segString = '0' + str(segmentNo + round[layer]*30)
    else:
        segString = str(segmentNo + round[layer]*30)

    name = 'layer' + str(layer) + '_' + segString + '.svc'
    file = open('user2_files/' + str(name),'wb')
    dat = ''
    while len(dat) < size:
        if size - len(dat) > 100000:
            dat = dat + s.recv(100000)
        elif size - len(dat) > 1000:
            dat = dat + s.recv(1000)
        elif size - len(dat) > 100:
            dat = dat + s.recv(100)
        else:
            dat = dat + s.recv(1)
    file.write(dat)
    file.close()
s.close()
