import serial
import matplotlib.pyplot as plt
import matplotlib.animation as animation
import numpy as np

size = 500

def animate(i, data, ser, mean, upperSTD, lowerSTD): 
    num = 0
    if ser.in_waiting:
        line = ser.readline()
        string = line.decode().rstrip()
        try:
            num = float(string)
            print(num)
            data.append(num)
        except:
            pass
    else:
        pass
    data = data[-size:]

    if data:
        calcMean = np.mean(data)
        mean.append(calcMean)
        std = (np.std(data))
        upperSTD.append(calcMean + std)
        lowerSTD.append(calcMean - std)
        
    mean = mean[-size:]


    upperSTD = upperSTD[-size:]
    lowerSTD = lowerSTD[-size:]

    ax.clear()
    ax.plot(data)
    ax.plot(mean, 'k')
    ax.plot(upperSTD, 'r')
    ax.plot(lowerSTD, 'r')
#   ax.set_ylim([0, 3000])
    ax.set_xlim([0, size])
    ax.set_title('Plot of Serial Data From Arduino')
    ax.set_xlabel('Samples')
    ax.set_ylabel('Amplitude (mV)')

data = []
mean = []
upperSTD = []
lowerSTD = []
fig, ax = plt.subplots()
ser = serial.Serial('COM4', 2000000, timeout=1)
ser.flush()

ani = animation.FuncAnimation(fig, animate, fargs=(data, ser, mean, upperSTD, lowerSTD), interval = 1, cache_frame_data=True)

plt.show()
