import serial
import serial.tools.list_ports
import matplotlib.pyplot as plt
import numpy as np

# Global Variables
size = 500
com = serial.tools.list_ports.comports()
data = []
bounds = [0, 0]
fig, ax = plt.subplots(3,2)
avrgSet = [1, 4, 16, 25, 100, 400]
ser = serial.Serial(com[0].device, 2000000, timeout=1)
ser.flush()
sampleSet = 0
j = 0
for row in ax:
    for col in row:
        sample = avrgSet[j]
        if(sample):
            ser.write(str(sample).encode())
            print('Averages: ' + str(sample))
            i = 0

            while(i < size):
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
                data = data[-size:]

            calcMean = np.mean(data)
            calcStd = np.std(data)

            dataMax = max(data)
            dataMin = min(data)
            if(j == 0):
                bounds[0] = dataMin
                bounds[1] = dataMax

            nBins = int(np.floor((dataMax - dataMin) * np.sqrt(int(sample)) / 0.8))
            i = 0

            col.hist(data, bins=nBins)
            #col.plot(data)
            col.set_title('Averages: ' + str(sample))
            col.set_xlabel('Voltage')
            col.set_ylabel('Frequency')  
            col.set_xlim(bounds)
            

        j += 1  


fig.tight_layout()
plt.show()