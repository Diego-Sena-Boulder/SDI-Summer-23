import serial
import serial.tools.list_ports
import matplotlib.pyplot as plt
import numpy as np

# Global Variables
com = serial.tools.list_ports.comports()
data1 = []
data2 = []
drainCurrent_mA = []
source_mV = []
drain_mV = []
thevanin_Ohm = []

multiplier_VperV = 2
sourceResistor_Ohm = 100
voltsADU = np.linspace(0, 3.3, 1024)
numAvg = 100
numPoints = 200
fig, ax = plt.subplots()

ser = serial.Serial(com[0].device, 2000000, timeout=1)
ser.flush()

for i in range(0,1024):
    ser.write((str(numAvg) + "/n" + str(numPoints) + "/n" + str(i)).encode())
    print('Averages: ' + str(numAvg) + ', with ' + str(numPoints) + ' samples, DAC_ADU: ' + str(i))
    j = 0
    while(j < numPoints):
        if ser.in_waiting:
            line = ser.readline()
            string = line.decode().rstrip().split(',')
            try:
                num1 = float(string[0]) * multiplier_VperV
                num2 = float(string[1]) * multiplier_VperV
                print(string[0] +  ", " + string[1])
                data1.append(num1)
                data2.append(num2)
                j += 1
            except:
                pass
        else:
            pass
        data1 = data1[-numPoints:]
        data2 = data2[-numPoints:]
    j = 0
        
        
    source_mV.append(np.mean(data1))
    drain_mV.append(np.mean(data2))
    drainCurrent_mA.append(source_mV/sourceResistor_Ohm)
    if drain_mV > 1:
        thevanin_Ohm.append((drain_mV[0] - drain_mV[i]) / drainCurrent_mA[i])


ax.plot(drain_mV, thevanin_Ohm)
ax.set_title('Current vs Voltage')
ax.set_xlabel('Current (mA)')
ax.set_ylabel('Resistance (\u03A9)')

plt.show()