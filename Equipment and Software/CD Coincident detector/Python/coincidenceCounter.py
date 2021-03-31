# -*- coding: utf-8 -*-
"""
Created on Wed Jul  1 03:05:23 2020
@author: Quynh
@author: Sahil
@author: Max
"""
# GUI for Coincidence counter. 
#import matplotlib.pyplot as plt    
from matplotlib import figure
from tkinter import *
from tkinter import filedialog
from tkinter.filedialog import asksaveasfile 
import PIL.Image
from matplotlib.backends.backend_tkagg import FigureCanvasTkAgg 
from matplotlib.backend_bases import key_press_handler
import matplotlib.pyplot as plt
from time import *
from tkinter.filedialog import asksaveasfile
from matplotlib import style
import matplotlib.animation as animation 
import threading
import time
import sys
import os
#from multiprocessing import Process

#port number might be different
#unquote the following if you have CD48 board connected

import serial



#file
###############################################################################
file_to_save = "Data.txt" #initial save file, will be overwritten by the save button

init_list = []#initial list of counts to be plotted

#writes a single value to the data file
def write_to_file(string):
    f = open(file_to_save, "a+")
    formatted_string = string + "\n"
    f.write(formatted_string)
    f.close()

#saves data file
def save(): 
    files = [('Text Document', '*.txt')] 
    file = asksaveasfile(filetypes = files, defaultextension = files)
    
    f = open(file_to_save, "r")
    for s in f.readlines():
        file.write(s)
    f.close()
    
    
    
port = "COM3"
baud = 115200
# # open the serial port
ser = serial.Serial(port, baud)
if ser.isOpen():
     print(ser.name + ' is open...')
else:
    ser.open()
#Gets data from the CD48 device and adds it to the initial list    
def get_data():
    while True:
        try:
            serial_data = ser.readline()
            serial_data = (serial_data.decode()).strip()
            init_list.append(serial_data)
            
        except TypeError:
            pass
#convert trigger level from voltage to a byte(0-255) 
#arg trigLevel is an float (0-4.02V)
#return value looks like L100
def trigg_cmd():
    triggLevel = slider.get()
    trigg_byte = triggLevel/402 * 256
    string= 'L' + str(trigg_byte) +"\r"
    return string
# return the command that will be send to the board for setting counter
# output will looks like S01001
def set_counter_cmd(counter_number, var_A, var_B, var_C, var_D):
    cmd_str='S'+str(counter_number) + str(var_A.get()) + str(var_B.get())+str(var_C.get())+str(var_D.get())
    cmd_str.replace(" ","")
    cmd_str.replace(",","")
    return cmd_str

#get impeandance selection
def z_cmd():
    if var.get()==2:
        return str("Z\r")
    if var.get()==1:
        return str("z\r")

def r_cmd(): 
    cmd = 'r' + str(repeat_time.get()) + '\r'
    return cmd
#run command and return output
#arg command is a string



#set global process ID

#define figure
fig = plt.figure(figsize=(18,8))
c0 = fig.add_subplot(241)  
c1 = fig.add_subplot(242) 
c2 = fig.add_subplot(243) 
c3 = fig.add_subplot(244) 
c4 = fig.add_subplot(245) 
c5 = fig.add_subplot(246) 
c6 = fig.add_subplot(247) 
c7 = fig.add_subplot(248) 
sub_plot_list = [c0,c1,c2,c3,c4,c5,c6,c7]
fig.subplots_adjust(wspace=0.5, hspace= 0.5)  

xList = []
y0 = []
y1=[]
y2=[]
y3=[]
y4=[]
y5=[]
y6=[]
y7=[]
    
y_list = [y0,y1,y2,y3,y4,y5,y6,y7]
def animate(i, sub_plot_list, period): 
    '''f = open(file_to_save, "r")
    lines = f.readlines'''
    
    #To get ignore the settings, only read out the data
    #data = (lines[i+15])
    #data.strip()
    
    data = init_list[i+2].split(" ") #list of counts at different counter
    #init_list[i] = 0
    count_list = []
    for count in data:
        count_list.append(int(count))
    #y_list now looks like: [y0,y1,y2,y3,y4,y5,y6,y7]
    count_rate=[0,0,0,0,0,0,0,0]
    period = period/1000
    y_length = len(y_list[1])
    xList.append(period*(y_length+1))
    #when no overflow occur
    if count_list[8] == 0:  
       
        
        for j in range(8):
            y_list[j].append(int(count_list[j]))
            
            if i < 2: 
                (y_list[j])[i]=0
                count_rate[j] = 0
        
            else: 
                count_rate[j] = (sum(y_list[j]))/(xList[-1] - 2*period)
                write_to_file(init_list[i])
                
            
            sub_plot_list[j].cla()
        
            if i>=40:
                sub_plot_list[j].plot(xList[-40:-1], (y_list[j])[-40:-1])
                count_rate[j] = (sum((y_list[j])[-40:-1]))/(40*period)
            else: 
                sub_plot_list[j].plot(xList, y_list[j])
            
            sub_plot_list[j].set_title("Counter " + str(j) +", rate: " + str("{:.2f}".format(count_rate[j])) + " cps")
            sub_plot_list[j].set(xlabel="time(s)", ylabel="counts")
    else:
        ser.write('E\r'.encode('utf-8'))
        '''popup.tkraise(root)
        popup = tk.Toplevel(root)
        
        tk.Label(popup,text = "overflow error").pack(side = "top",fill = "x",pady = 10)
        tk.Button(popup, text = "clear overflow",command = popup.destroy).pack()'''
        init_list.clear()
        fig.clf()

    return sub_plot_list


def setParameter():
    #reset the file:
    f = open(file_to_save, "w+")
    f.write("Counter settings and data\n\n")
    f.close()
    ###take all user input and send to the board: 
    #impeadance
    z = z_cmd()
    ser.write(z.encode('utf-8'))
    if z == "z":
        write_to_file("Impedance: low")
    elif z == "Z":
        write_to_file("Impedance: high")
        
    #set coincidence channels to counters
    c0_cmd = set_counter_cmd('0',var_A0, var_B0, var_C0, var_D0)
    c1_cmd = set_counter_cmd('1',var_A1, var_B1, var_C1, var_D1)
    c2_cmd = set_counter_cmd('2',var_A2, var_B2, var_C2, var_D2)
    c3_cmd = set_counter_cmd('3',var_A3, var_B3, var_C3, var_D3)
    c4_cmd = set_counter_cmd('4',var_A4, var_B4, var_C4, var_D4)
    c5_cmd = set_counter_cmd('5',var_A5, var_B5, var_C5, var_D5)
    c6_cmd = set_counter_cmd('6',var_A6, var_B6, var_C6, var_D6)
    c7_cmd = set_counter_cmd('7',var_A7, var_B7, var_C7, var_D7)
    
    #write all of the channel settings to the data file
    write_to_file(c0_cmd.replace("S0", "Counter 0: "))
    write_to_file(c1_cmd.replace("S1", "Counter 1: "))
    write_to_file(c2_cmd.replace("S2", "Counter 2: "))
    write_to_file(c3_cmd.replace("S3", "Counter 3: "))
    write_to_file(c4_cmd.replace("S4", "Counter 4: "))
    write_to_file(c5_cmd.replace("S5", "Counter 5: "))
    write_to_file(c6_cmd.replace("S6", "Counter 6: "))
    write_to_file(c7_cmd.replace("S7", "Counter 7: "))
    
    #write channel settings to the port
    ser.write(c0_cmd.encode('utf-8'))
    ser.write(c1_cmd.encode('utf-8'))
    ser.write(c2_cmd.encode('utf-8'))
    ser.write(c3_cmd.encode('utf-8'))
    ser.write(c4_cmd.encode('utf-8'))
    ser.write(c5_cmd.encode('utf-8'))
    ser.write(c6_cmd.encode('utf-8'))
    ser.write(c7_cmd.encode('utf-8'))
    
    
    #set trigger level
    Ln = trigg_cmd()
    ser.write(Ln.encode('utf-8'))
    write_to_file("Trigger Level: " + str(slider.get()) +" mV")
    
    write_to_file("repeat interval: " + str(repeat_time.get()) + " ms")
    
    if str(integration_time.get()) == "":
        write_to_file("Integration time is not defined")
    else: 
        write_to_file("Integration time: " + str(integration_time.get()) + " ms")
    rn = r_cmd() #toggle should be off before setting repeat period

    ser.write(rn.encode('utf-8'))
    ser.write("R".encode("utf-8")) #turn back on
    t1 = threading.Thread(target = get_data)
    t1.daemon = True
    t1.start()
  
   

    
def start_plot():
    period = int(repeat_time.get())
    fig.suptitle("Real time counts with timebin = " + str(period/1000) +" s")
    int_time = integration_time.get()
    if str(int_time) == "" or int_time.isnumeric() == False:
        ani = animation.FuncAnimation(fig, animate, fargs=(sub_plot_list, period), blit = False, interval= period)
    else:
        frames_n = (int(int_time))/(int(period))
        ani = animation.FuncAnimation(fig, animate, fargs=(sub_plot_list, period), blit = False, interval= period, frames = int(frames_n), repeat = False)
       
    
    
    
    '''canvas = FigureCanvasTkAgg(fig, master=root)
    canvas.get_tk_widget().grid(row = 0, column = 7, rowspan = 15, columnspan = 14, padx = (10,0), pady = (30,0))
    canvas.draw()'''
    
   
    plt.show()
#turn on all LED for 1s
def test():
    ser.close()
    ser.open()
    ser.write('T'.encode('utf-8'))


def done():
    ser.close()
    root.destroy()
    sys.exit()
    
def default():
    repeat_time.delete(0, END)
    integration_time.delete(0, END)
    var.set(1)
    var_A0.set(1)
    var_B0.set(0)
    var_C0.set(0)
    var_D0.set(0)
    
    var_A1.set(0)
    var_B1.set(1)
    var_C1.set(0)
    var_D1.set(0)
    
    var_A2.set(0)
    var_B2.set(0)
    var_C2.set(1)
    var_D2.set(0)
    
    var_A3.set(0)
    var_B3.set(0)
    var_C3.set(0)
    var_D3.set(1)
    
    var_A4.set(1)
    var_B4.set(1)
    var_C4.set(0)
    var_D4.set(0)
    
    var_A5.set(1)
    var_B5.set(0)
    var_C5.set(1)
    var_D5.set(0)
    
    var_A6.set(1)
    var_B6.set(0)
    var_C6.set(0)
    var_D6.set(1)
    
    var_A7.set(0)
    var_B7.set(1)
    var_C7.set(1)
    var_D7.set(1)
    
    A0.select()
    B0.deselect()
    C0.deselect()
    D0.deselect()
    
    A1.deselect()
    B1.select()
    C1.deselect()
    D1.deselect()
    
    A2.deselect()
    B2.deselect()
    C2.select()
    D2.deselect()
    
    A3.deselect()
    B3.deselect()
    C3.deselect()
    D3.select()
    
    A4.select()
    B4.select()
    C4.deselect()
    D4.deselect()
    
    A5.select()
    B5.deselect()
    C5.select()
    D5.deselect()
    
    A6.select()
    B6.deselect()
    C6.deselect()
    D6.select()
    
    A7.deselect()
    B7.select()
    C7.select()
    D7.select()
    
    repeat_time.delete(0, END)
    repeat_time.insert(0, "1000")
    
    integration_time.delete(0, END)
    integration_time.insert(0, "10000")
    
    slider.set(200)

def reset():
    ser.write("R".encode('utf-8'))
    init_list.clear()
    os.remove(file_to_save)
    default()


def clear_plot():
    fig.clf()
root = Tk() 
root.title('Coincidence Counter') 

    
# create window geometry limits
root.geometry('{}x{}'.format(400, 900))
root.maxsize(width=1800, height = 900)
root.minsize(width=200, height = 200)

# create all of the main containers
left_top = Frame(root, bg = 'floralwhite', width = 400, height = 600)
left_btm = Frame(root, bg = 'floralwhite', width = 400, height = 300)
#right_top = Frame(root, bg = 'Lavender', width = 1310, height = 600)
#right_btm = Frame(root, bg = 'lavender', width = 1310, height = 300)


# layout all of the main containers
# 20x20 grid -- arrange widgets by gridspan on uniform grid
Grid.rowconfigure(root, 0, weight = 1)
Grid.rowconfigure(root, 1, weight = 1)
Grid.rowconfigure(root, 2, weight = 1)
Grid.rowconfigure(root, 3, weight = 1)
Grid.rowconfigure(root, 4, weight = 1)
Grid.rowconfigure(root, 5, weight = 1)
Grid.rowconfigure(root, 6, weight = 1)
Grid.rowconfigure(root, 7, weight = 1)
Grid.rowconfigure(root, 8, weight = 1)
Grid.rowconfigure(root, 9, weight = 1)
Grid.rowconfigure(root, 10, weight = 1)
Grid.rowconfigure(root, 11, weight = 1)
Grid.rowconfigure(root, 12, weight = 1)
Grid.rowconfigure(root, 13, weight = 1)
Grid.rowconfigure(root, 14, weight = 1)
Grid.rowconfigure(root, 15, weight = 1)
Grid.rowconfigure(root, 16, weight = 1)
Grid.rowconfigure(root, 17, weight = 1)
Grid.rowconfigure(root, 18, weight = 1)
Grid.rowconfigure(root, 19, weight = 1)
Grid.rowconfigure(root, 20, weight = 1)
Grid.columnconfigure(root, 0, weight = 1)
Grid.columnconfigure(root, 1, weight = 1)
Grid.columnconfigure(root, 2, weight = 1)
Grid.columnconfigure(root, 3, weight = 1)
Grid.columnconfigure(root, 4, weight = 1)
Grid.columnconfigure(root, 5, weight = 1)
Grid.columnconfigure(root, 6, weight = 1)
Grid.columnconfigure(root, 7, weight = 1)
Grid.columnconfigure(root, 8, weight = 1)
Grid.columnconfigure(root, 9, weight = 1)
Grid.columnconfigure(root, 10, weight = 1)
Grid.columnconfigure(root, 11, weight = 1)
Grid.columnconfigure(root, 12, weight = 1)
Grid.columnconfigure(root, 13, weight = 1)
Grid.columnconfigure(root, 14, weight = 1)
Grid.columnconfigure(root, 15, weight = 1)
Grid.columnconfigure(root, 16, weight = 1)
Grid.columnconfigure(root, 17, weight = 1)
Grid.columnconfigure(root, 18, weight = 1)
Grid.columnconfigure(root, 19, weight = 1)
Grid.columnconfigure(root, 20, weight = 1)

# assign 3 regions to grid (technically 4 regions, but 3 colored regions as per GUI map)
left_top.grid(row = 0, column = 0, rowspan = 11, columnspan = 8, sticky = "nw")
left_btm.grid(row = 11, column = 0, rowspan = 10, columnspan = 8, sticky = "sw")
#right_top.grid(row = 0, column = 8, rowspan = 11, columnspan = 13, sticky = "ne")
#right_btm.grid(row = 11, column = 8, rowspan = 10, columnspan = 13, sticky = "se")

###############################################################################
#initial plot
'''fig.suptitle("Real time count data")
canvas = FigureCanvasTkAgg(fig, master=root)
canvas.get_tk_widget().grid(row = 0, column = 7, rowspan = 15, columnspan = 14, padx = (10,0), pady = (30,0))'''
###############################################################################

# label for impedance selection
Label(root, text = "Impedance (\u03A9):").grid(row = 0, column = 0, columnspan=2, pady=(15,0), padx = (70,0))
var = IntVar()
high = Radiobutton(root, text = "High", variable = var, value = 2)
high.grid(row = 0, column = 1,columnspan=2, pady=(15,0), padx = (90,0))
low = Radiobutton(root, text = "Low", variable = var, value = 1)
low.grid(row = 0, column = 2,columnspan=2, pady=(15,0), padx = (70,0))


###############################################################################
# do the following to import user selections into the console
# def show_values():
#     print (var_A.get(), var_B.get(), ...)
# Button(root, text = "get values", command = show_values).grid(...)
###############################################################################

Label(root, text = "Trigger Level Sliders (0-4.02V)").grid(row = 1, column = 0, columnspan=5, pady=(10,0))
slider = Scale(root, from_ = 0, to = 402, length=400, tickinterval = 50, orient=HORIZONTAL) # creates the slider from 0 to 100
slider.set(150) # sets initial slider value
slider.grid(row = 2, column=0, columnspan=6, padx = (10,0)) # assigns slider on grid. note: adding .grid at the end of scale defn does not compile
 

###############################################################################
# do the following to import user selections into the console
# def show_values():
#     print (A_slider.get(), B_slider.get(), ...)
# Button(root, text = "get values", command = show_values).grid(...)
###############################################################################
Label(root, text = "Repeat period (ms)").grid(row = 3, column = 0, columnspan = 3, padx =(15,0))
repeat_time = Entry(root, width = 8)
repeat_time.grid(row = 3, column = 3)

Label(root, text = "Integration Time Box:").grid(row = 4, column = 0, columnspan = 3, padx = (30,0))
integration_time = Entry(root, width = 8)
integration_time.grid(row = 4, column = 3)
# add restriction depending on what type of user input is required

###############################################################################
# do the following to import user selections into the console
# def show_values():
#     print (integration_time.get())
# Button(root, text = "get values", command = show_values).grid(...)
###############################################################################

Label(root, text = "Select Counters").grid(row = 5, column = 0, columnspan = 5)

# for counter 0:
Label(root, text = "Counter 0:").grid(row = 6, column = 0, padx=(15,0))
var_A0 = IntVar()
var_B0 = IntVar()
var_C0 = IntVar()
var_D0 = IntVar()
A0 = Checkbutton(root, text = "A", variable = var_A0, onvalue = 1, offvalue = 0, width = 7)
A0.grid(row = 6, column = 1)
B0 = Checkbutton(root, text = "B", variable = var_B0, onvalue = 1, offvalue = 0, width = 7)
B0.grid(row = 6, column = 2)
C0 = Checkbutton(root, text = "C", variable = var_C0, onvalue = 1, offvalue = 0, width = 7)
C0.grid(row = 6, column = 3)
D0 = Checkbutton(root, text = "D", variable = var_D0, onvalue = 1, offvalue = 0, width = 7)
D0.grid(row = 6, column = 4)

# for counter 1:
Label(root, text = "Counter 1:").grid(row = 7, column = 0, padx=(15,0))
var_A1 = IntVar()
var_B1 = IntVar()
var_C1 = IntVar()
var_D1 = IntVar()
A1 = Checkbutton(root, text = "A", variable = var_A1, onvalue = 1, offvalue = 0, width = 7)
A1.grid(row = 7, column = 1)
B1 = Checkbutton(root, text = "B", variable = var_B1, onvalue = 1, offvalue = 0, width = 7)
B1.grid(row = 7, column = 2)
C1 = Checkbutton(root, text = "C", variable = var_C1, onvalue = 1, offvalue = 0, width = 7)
C1.grid(row = 7, column = 3)
D1 = Checkbutton(root, text = "D", variable = var_D1, onvalue = 1, offvalue = 0, width = 7)
D1.grid(row = 7, column = 4)

# for counter 2:
Label(root, text = "Counter 2:").grid(row = 8, column = 0, padx=(15,0))
var_A2 = IntVar()
var_B2 = IntVar()
var_C2 = IntVar()
var_D2 = IntVar()
A2 = Checkbutton(root, text = "A", variable = var_A2, onvalue = 1, offvalue = 0, width = 7)
A2.grid(row = 8, column = 1)
B2 = Checkbutton(root, text = "B", variable = var_B2, onvalue = 1, offvalue = 0, width = 7)
B2.grid(row = 8, column = 2)
C2 = Checkbutton(root, text = "C", variable = var_C2, onvalue = 1, offvalue = 0, width = 7)
C2.grid(row = 8, column = 3)
D2 = Checkbutton(root, text = "D", variable = var_D2, onvalue = 1, offvalue = 0, width = 7)
D2.grid(row = 8, column = 4)

# for counter 3:
Label(root, text = "Counter 3:").grid(row = 9, column = 0, padx=(15,0))
var_A3 = IntVar()
var_B3 = IntVar()
var_C3 = IntVar()
var_D3 = IntVar()
A3 = Checkbutton(root, text = "A", variable = var_A3, onvalue = 1, offvalue = 0, width = 7)
A3.grid(row = 9, column = 1)
B3 = Checkbutton(root, text = "B", variable = var_B3, onvalue = 1, offvalue = 0, width = 7)
B3.grid(row = 9, column = 2)
C3 = Checkbutton(root, text = "C", variable = var_C3, onvalue = 1, offvalue = 0, width = 7)
C3.grid(row = 9, column = 3)
D3 = Checkbutton(root, text = "D", variable = var_D3, onvalue = 1, offvalue = 0, width = 7)
D3.grid(row = 9, column = 4)

# for counter 4:
Label(root, text = "Counter 4:").grid(row = 10, column = 0, padx=(15,0))
var_A4 = IntVar()
var_B4 = IntVar()
var_C4 = IntVar()
var_D4 = IntVar()
A4 = Checkbutton(root, text = "A", variable = var_A4, onvalue = 1, offvalue = 0, width = 7)
A4.grid(row = 10, column = 1)
B4 = Checkbutton(root, text = "B", variable = var_B4, onvalue = 1, offvalue = 0, width = 7)
B4.grid(row = 10, column = 2)
C4 = Checkbutton(root, text = "C", variable = var_C4, onvalue = 1, offvalue = 0, width = 7)
C4.grid(row = 10, column = 3)
D4 = Checkbutton(root, text = "D", variable = var_D4, onvalue = 1, offvalue = 0, width = 7)
D4.grid(row = 10, column = 4)

# for counter 5:
Label(root, text = "Counter 5:").grid(row = 11, column = 0, padx=(15,0))
var_A5 = IntVar()
var_B5 = IntVar()
var_C5 = IntVar()
var_D5 = IntVar()
A5 = Checkbutton(root, text = "A", variable = var_A5, onvalue = 1, offvalue = 0, width = 7)
A5.grid(row = 11, column = 1)
B5 = Checkbutton(root, text = "B", variable = var_B5, onvalue = 1, offvalue = 0, width = 7)
B5.grid(row = 11, column = 2)
C5 = Checkbutton(root, text = "C", variable = var_C5, onvalue = 1, offvalue = 0, width = 7)
C5.grid(row = 11, column = 3)
D5 = Checkbutton(root, text = "D", variable = var_D5, onvalue = 1, offvalue = 0, width = 7)
D5.grid(row = 11, column = 4)

# for counter 6:
Label(root, text = "Counter 6:").grid(row = 12, column = 0, padx=(15,0))
var_A6 = IntVar()
var_B6 = IntVar()
var_C6 = IntVar()
var_D6 = IntVar()
A6 = Checkbutton(root, text = "A", variable = var_A6, onvalue = 1, offvalue = 0, width = 7)
A6.grid(row = 12, column = 1)
B6 = Checkbutton(root, text = "B", variable = var_B6, onvalue = 1, offvalue = 0, width = 7)
B6.grid(row = 12, column = 2)
C6 = Checkbutton(root, text = "C", variable = var_C6, onvalue = 1, offvalue = 0, width = 7)
C6.grid(row = 12, column = 3)
D6 = Checkbutton(root, text = "D", variable = var_D6, onvalue = 1, offvalue = 0, width = 7)
D6.grid(row = 12, column = 4)

# for counter 7:
Label(root, text = "Counter 7:").grid(row = 13, column = 0, padx=(15,0))
var_A7 = IntVar()
var_B7 = IntVar()
var_C7 = IntVar()
var_D7 = IntVar()
A7 = Checkbutton(root, text = "A", variable = var_A7, onvalue = 1, offvalue = 0, width = 7)
A7.grid(row = 13, column = 1)
B7 = Checkbutton(root, text = "B", variable = var_B7, onvalue = 1, offvalue = 0, width = 7)
B7.grid(row = 13, column = 2)
C7 = Checkbutton(root, text = "C", variable = var_C7, onvalue = 1, offvalue = 0, width = 7)
C7.grid(row = 13, column = 3)
D7 = Checkbutton(root, text = "D", variable = var_D7, onvalue = 1, offvalue = 0, width = 7)
D7.grid(row = 13, column = 4)


default()

Button(root, text = "Set Parameter Values", command= setParameter).grid(row = 16, column = 0, rowspan = 2, columnspan = 3) # add command to this button
Button(root, text = "Reset", command= reset).grid(row = 16, column = 3, rowspan = 2, columnspan = 2) # add command to this button
Button(root, text = "Test board", command= test).grid(row = 18, column = 3, rowspan = 1, columnspan = 2) # add command to this button
###############################################################################


# live updating widgets can be placed upon a canvas:


Button(root, text = "Clear Plots", command=clear_plot).grid(row = 18, column = 1, columnspan = 2)
Button(root, text = "Start Plot", command=start_plot).grid(row = 18, column = 0, columnspan = 2, padx=(25,0))
#Button(root, text = "Stop").grid(row = 17, column = 9, columnspan = 2)
Button(root, text = "Save Data & Settings",command = save).grid(row = 19, column = 0, columnspan = 3, padx=(10,0))


    
Button(root, text = "Quit", command=done).grid(row = 19, column = 3,  columnspan=4)

root.mainloop()
