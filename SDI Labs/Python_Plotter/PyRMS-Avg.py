import serial
import serial.tools.list_ports
import matplotlib.pyplot as plt
import numpy as np

# Global Variables
com = serial.tools.list_ports.comports()
calcStd = []
integrationTime = []
data = []
fig, ax = plt.subplots()
avrgSet = [[1, 500], [4, 500], [16, 500], [25, 500], [100, 200], [400, 200], [1000, 200],
           [4000, 200], [16000, 200], [50000, 200], [100000, 200], [200000, 200]]

ser = serial.Serial(com[0].device, 2000000, timeout=1)
ser.flush()
sampleSet = 0

for j in avrgSet:
    integrationTime.append(j[0] * 22 / 1000)
    if(j[0]):
        ser.write((str(j[0]) + "/n" + str(j[1])).encode())
        print('Averages: ' + str(j[0]) + ', with ' + str(j[1]) + ' samples')
        
        i = 0
        while(i < j[1]):
            num = 0
            if ser.in_waiting:
                line = ser.readline()
                string = line.decode().rstrip()
                try:
                    num = float(string)
                    #print(num)
                    data.append(num)
                    i += 1
                except:
                    pass
            else:
                pass
            data = data[-j[1]:]

        calcStd.append(np.std(data))

        i = 0
        
ax.scatter(integrationTime, calcStd, alpha=0.7, edgecolors="red")
ax.set_xscale("log")
ax.set_yscale("log")
ax.set_title('STD vs Integration Time')
ax.set_xlabel('Integration Time (ms)')
ax.set_ylabel('Standard Deviation (mV)')


plt.show()