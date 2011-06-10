import socket
import binascii
import struct

s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
s.bind(('', 50000))
s.listen(1)

connection, address = s.accept()

print 'Connection from', address

while 1:
	data = connection.recv(1024)
	if not data: break
	while len(data) > 0:
		#print '%s' % struct.unpack('>H', data)
		datum = struct.unpack('!H', data[0:2])
		pan = (datum[0] & 0x7800) >> 9;
		
		print 'Value: %H' % datum[0]
		print 'Pan: %H' % pan
		
		data = data[2:len(data)-2]
connection.close()
