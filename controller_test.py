import triad_openvr
import time
import sys
import matplotlib.pyplot as plt
from drawnow import drawnow
from mpl_toolkits import mplot3d
from mpl_toolkits.mplot3d import Axes3D

#trialName = 'VR_SubjP03_Practice_Play_TR01'
trialName = 'Test'

plt.close()
# Make figures to update using subplot for yaw,pitch,roll
def angle1():
    plt.subplot(311)
    plt.plot(frame,yaw1)
    plt.title('Yaw')
    plt.subplot(312)
    plt.plot(frame,pitch1)
    plt.title('Pitch')
    plt.subplot(313)
    plt.plot(frame,roll1)
    plt.title('Roll')
def position1():
    plt.subplot(311)
    plt.plot(frame,x1)
    plt.title('X')
    plt.subplot(312)
    plt.plot(frame,y1)
    plt.title('Y')
    plt.subplot(313)
    plt.plot(frame,z1)
    plt.title('Z')
def angle2():
    plt.subplot(311)
    plt.plot(frame,yaw2)
    plt.title('Yaw')
    plt.subplot(312)
    plt.plot(frame,pitch2)
    plt.title('Pitch')
    plt.subplot(313)
    plt.plot(frame,roll2)
    plt.title('Roll')
def position2():
    plt.subplot(311)
    plt.plot(frame,x2)
    plt.title('X')
    plt.subplot(312)
    plt.plot(frame,y2)
    plt.title('Y')
    plt.subplot(313)
    plt.plot(frame,z2)
    plt.title('Z')
def txt2str(txt):
    txtNumList = [float(s) for s in txt.split()]
    return txtNumList
# Initialization for the controller code
v = triad_openvr.triad_openvr()
v.print_discovered_objects()

if len(sys.argv) == 1:
    interval = 1/250
elif len(sys.argv) == 2:
    interval = 1/float(sys.argv[0])
else:
    print("Invalid number of arguments")
    interval = False
    
control1, control1txt = [],[]
control2, control2txt = [],[]
x1, x2 = [],[]
y1, y2 = [],[]
z1, z2 = [],[]
yaw1, yaw2 = [],[]
pitch1, pitch2 = [],[]
roll1, roll2 = [],[]
frame = []
tStart = time.time()
if interval:
    try:
        i = 0
        while(True):
            start = time.time()
            txt1 = ""
            # Loop and grab coordinates for controller 1
            for each in v.devices["controller_1"].get_pose_euler():
                txt1 += "%.4f" % each
                txt1 += " "
            print("\rController 1: " + txt1, end="")
            txt2 = ""
            print()
            # Loop and grab coordinates for controller 2
            for each in v.devices["controller_2"].get_pose_euler():
                txt2 += "%.4f" % each
                txt2 += " "
            print("\rController 2: " + txt2, end="\n")
            print()
            # Add controller 1 and controller 2 coordinates to list
            sleep_time = interval-(time.time()-start)
            if sleep_time>0:
                time.sleep(sleep_time)
            frame.append(i)
            
            
            txt1Num = txt2str(txt1)
            txt2Num = txt2str(txt2)
            control1.append(txt1Num)
            control2.append(txt2Num)
            control1txt.append(txt1)
            control2txt.append(txt2)
            
            x1.append(control1[i][0])
            y1.append(control1[i][1])
            z1.append(control1[i][2])
            
            yaw1.append(control1[i][3])
            pitch1.append((control1[i][4]))
            roll1.append(control1[i][5])
            
            x2.append(control2[i][0])
            y2.append(control2[i][1])
            z2.append(control2[i][2])
            
            yaw2.append(control2[i][3])
            pitch2.append((control2[i][4]))
            roll2.append(control2[i][5])
            i = i+1
            # Plotting
            drawnow(position1)
#            tPassed = time.time()-tStart
#            if tPassed>=10:
#                raise KeyboardInterrupt('time"s up!')
    except KeyboardInterrupt:
        # When ctrl+c is pressed, there is a keyboard interrupt
        # Write each line into a .csv file
        control1Name = trialName+'control1.csv'
        control2Name = trialName+'control2.csv'
        with open(control1Name,'w') as file:
            for line in control1txt:
                file.write(line)
                file.write('\n')
        with open(control2Name,'w') as file:
            for line in control2txt:
                file.write(line)
                file.write('\n')
        print('Trial Ended')