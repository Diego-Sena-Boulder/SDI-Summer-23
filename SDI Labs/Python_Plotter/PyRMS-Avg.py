import serial
import matplotlib.pyplot as plt
import numpy as np

# Global Variables
size = 500
calcStd = []
data = []
fig, ax = plt.subplots()
avrgSet = [1, 4, 16, 25, 100, 400]
ser = serial.Serial('COM4', 2000000, timeout=1)
ser.flush()
sampleSet = 0
for j in avrgSet:
    sample = j
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

        calcStd = np.std(data)

        i = 0
        



plt.show()