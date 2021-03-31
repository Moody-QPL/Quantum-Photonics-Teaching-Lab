# -*- coding: utf-8 -*-
"""
Created on Sun Sep 27 15:03:38 2020

@author: quynh
"""


##python 3.7
'''created Jul 4
@author: Quynh Dang
'''

import serial
import sys

port = "COM5"
baud = 9600
  
ser = serial.Serial(port, baud, timeout=1)
    # open the serial port
if ser.isOpen():
     print(ser.name + ' is open...')
   
while True:
    #cmd = raw_input("Enter command or 'exit':")
        # for Python 2
    cmd = input("Enter command or 'exit':") +'\r'
        # for Python 3
    if cmd == 'exit\r':
        ser.close()
        sys.exit()
        
    else:
        ser.write(cmd.encode('utf-8'))
        out = ser.readlines()
        for i in range(len(out)):
            
            print((out[i].decode()).strip())