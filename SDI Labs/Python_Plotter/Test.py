import serial
import serial.tools.list_ports
import matplotlib.pyplot as plt
import matplotlib.animation as animation
import numpy as np

# Global Variables
com = serial.tools.list_ports.comports()

data1 = []
data2 = []
fig, ax = plt.subplots()

ser = serial.Serial(com[0].device, 2000000, timeout=1)
ser.flush()

size = 500

def animate(i, data1, data2, ser): 
    num = 0
    if ser.in_waiting:
        line = ser.readline()
        string = line.decode().rstrip().split(',')
        try:
            num = float(string)
            print(num)
            data1.append(num[0])
            data2.append(num[1])
        except:
            pass
    else:
        pass
    data1 = data1[-size:]
    data2 = data2[-size:]

    ax.clear()
    ax.plot(data1)
    ax.plot(data2)
    ax.set_xlim([0, size])
    ax.set_title('Plot of Multiple Data Lines From Arduino')
    ax.set_xlabel('Samples')
    ax.set_ylabel('Amplitude (mV)')

ani = animation.FuncAnimation(fig, animate, fargs=(data1, data2, ser), interval = 1, cache_frame_data1=True)

plt.show()