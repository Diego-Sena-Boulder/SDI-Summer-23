import serial
import serial.tools.list_ports
import matplotlib.pyplot as plt
import numpy as np

# Global Variables
com = serial.tools.list_ports.comports()
data1 = []
data2 = []
current = []
voltsADU = []
fig, ax = plt.subplots()

avrgSet = [[1, 500, 0.0], [4, 500, 0.1], [16, 500], [25, 500], [100, 200], [400, 200], [1000, 200],
           [4000, 200], [16000, 200], [50000, 200], [100000, 200], [200000, 200]]

ser = serial.Serial(com[0].device, 2000000, timeout=1)
ser.flush()


ax.scatter(integrationTime, calcStd, alpha=0.7, edgecolors="red")
ax.set_title('Current vs Voltage')
ax.set_xlabel('Voltage (mV)')
ax.set_ylabel('Current (mA)')

plt.show()