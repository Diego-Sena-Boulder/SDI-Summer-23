import serial
import serial.tools.list_ports
import matplotlib.pyplot as plt
import numpy as np

# Global Variables
com = serial.tools.list_ports.comports()
data1 = []
data2 = []
sourceCurrent_mA = []
source_mV = []
drain_mV = []
thevenin_Ohm = []

multiplier_VperV = 2
sourceResistor_Ohm = 100.0
voltsADU = np.linspace(0, 3.3, 1024)
numAvg = 100
numPoints = 200
fig, ax = plt.subplots(3, 1)

ser = serial.Serial(com[0].device, 2000000, timeout=1)
ser.flush()
k = 0

ser.write((str(numAvg) + "," + str(numPoints) + ", 0" ).encode())
print('Averages: ' + str(numAvg) + ', with ' + str(numPoints) + ' samples, DAC_ADU: 0')
j = 0
while(j < numPoints):
    if ser.in_waiting:
        line = ser.readline()
        string = line.decode().rstrip().split(',')
        try:
            num1 = float(string[0]) * multiplier_VperV
            #print(string[0] +  ", " + string[1])
            data1.append(num1)
            j += 1
        except:
            pass
    else:
        pass
    data1 = data1[-numPoints:]

theveninVoltage = np.mean(data1)

for i in range(900 ,1024, 10):
    
    ser.write((str(numAvg) + "," + str(numPoints) + "," + str(i)).encode())
    print('Averages: ' + str(numAvg) + ', with ' + str(numPoints) + ' samples, DAC_ADU: ' + str(i))
    j = 0
    while(j < numPoints):
        if ser.in_waiting:
            line = ser.readline()
            string = line.decode().rstrip().split(',')
            try:
                num1 = float(string[0]) * multiplier_VperV
                num2 = float(string[1]) * multiplier_VperV
                #print(string[0] +  ", " + string[1])
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
           
    source_mV.append(np.mean(data2))
    drain_mV.append(np.mean(data1))
    sourceCurrent_mA.append(source_mV[k]/sourceResistor_Ohm)
    thevenin_Ohm.append((theveninVoltage - drain_mV[k]) / sourceCurrent_mA[k])
    
    k += 1

thevenin_Mean = np.mean(thevenin_Ohm)

ax[0].plot(sourceCurrent_mA, thevenin_Ohm)
ax[0].axhline(y = thevenin_Mean, color='r')
ax[0].set_title('Current vs Resistance, ' + 'Mean resistance: ' + '{:0.2f}'.format(thevenin_Mean) + '\u03A9')
ax[0].set_xlabel('Current (mA)')
ax[0].set_ylabel('Resistance (\u03A9)')

ax[1].plot(sourceCurrent_mA, drain_mV)
ax[1].set_title('Current vs Drain Voltae')
ax[1].set_xlabel('Current (mA)')
ax[1].set_ylabel('Voltage (mV)')

ax[2].plot(sourceCurrent_mA, source_mV)
ax[2].set_title('Current vs Source Voltage')
ax[2].set_xlabel('Current (mA)')
ax[2].set_ylabel('Voltage (mV)')

fig.tight_layout()
plt.show()