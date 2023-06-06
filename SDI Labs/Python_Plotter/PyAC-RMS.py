import serial
import matplotlib.pyplot as plt
import numpy as np

# Global Variables
size = 500

data = []
bounds = [0, 0]
fig, ax = plt.subplots(3,2)
avrgSet = [1, 4, 16, 25, 100, 400]
ser = serial.Serial('COM4', 2000000, timeout=1)
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

            if(j == 0):
                bounds[0] = min(data) - 1
                bounds[1] = max(data) + 1

            i = 0

            col.plot(data)
            col.axhline(y = calcMean, color='r')
            col.axhline(y = calcMean + calcStd, color='k')
            col.axhline(y = calcMean - calcStd, color='k')
            col.set_title('Averages: ' + str(sample))
            col.set_xlabel('Voltage')
            col.set_ylabel('Frequency')  
            col.set_ylim(bounds)
            

        j += 1  


fig.tight_layout()
plt.show()