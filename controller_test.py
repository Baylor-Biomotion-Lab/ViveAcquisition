import triad_openvr
import time
import sys
import matplotlib.pyplot as plt
#import ctypes
from threading import Thread


#plotControllerCSV(trialName)


#trialName = 'test'
trialName = 'VR_VRValidation_RS9_'+'RRPFP'+'_TR'+'30'
plt.close()
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
    
control1txt = []
control2txt = []
rtemps1 = []
rtemps2 = []
x= [] 
y = []
z = []
tStart = time.time()

def writeViveFiles():
    control1Name = trialName+'control1.csv'
    control2Name = trialName+'control2.csv'
    control1RotMatName = trialName+'control1RotMat.csv'
    control2RotMatName = trialName+'control2RotMat.csv'
    tPassed = time.time()-tStart
    print(tPassed)
    # Check to see if we have exceeded the computational power required to keep this thing running > 200 Hz
    if len(control1txt)<(tPassed*200):
        print("Frame rate below 200 Hz, retry.")
    # If we are recording correctly, write csv files with ridiculously long names
    with open(control1Name,'w') as file:
        for line in control1txt:
            file.write(line)
            file.write('\n')
    with open(control2Name,'w') as file:
        for line in control2txt:
            file.write(line)
            file.write('\n')
    # Rotation matrices have to be extracted so they write nicely to .csv
    with open(control1RotMatName,'w') as file:
        for rt1 in rtemps1:
            for row1 in rt1:
                [file.write(str(row1[x])+',') if x<len(row1)-1 else file.write(str(row1[x])+'\n') for x in range(len(row1)) ]
    with open(control2RotMatName,'w') as file:
        for rt2 in rtemps2:
            for row2 in rt2:
                [file.write(str(row2[x])+',') if x<len(row2)-1 else file.write(str(row2[x])+'\n') for x in range(len(row2)) ]
    
if interval:
    try:
        i = 0
        while(True):
            start = time.time()
            txt11 = ""
            # Loop and grab coordinates for controller 1
            for each in v.devices["controller_1"].get_pose_euler():
                txt11 += "%.4f" % each
                txt11 += " "
            print("\rController 1: " + txt11, end="")
            txt21 = ""
            print()
            
            # Loop and grab coordinates for controller 2
            for each in v.devices["controller_2"].get_pose_euler():
                txt21 += "%.4f" % each
                txt21 += " "
            print("\rController 2: " + txt21, end="\n")
            print()
            
            txt12 = ""
            for each in v.devices["controller_1"].get_pose_quaternion():
                txt12 += "%.4f" % each
                txt12 += " "
            txt22 = ""
            for each in v.devices["controller_2"].get_pose_quaternion():
                txt22 += "%.4f" % each
                txt22 += " "
            
            # Get pose matrices for controllers 1 and 2
            rtemp1 = v.devices["controller_1"].get_RotMat()
            rtemp2 = v.devices["controller_2"].get_RotMat()
            sleep_time = interval-(time.time()-start)
            
            if sleep_time>0:
                time.sleep(sleep_time)           
            
            control1txt.append(txt11+txt12)
            control2txt.append(txt21+txt22)
            rtemps1.append(rtemp1)
            rtemps2.append(rtemp2)
            
            
            
            # Stop script if it runs more than 10 seconds
#            tPassed = time.time()-tStart
#            if tPassed>=10:
#                raise KeyboardInterrupt('time"s up!')
    except KeyboardInterrupt:
        # When ctrl+c is pressed, there is a keyboard interrupt
        # Write each line into a .csv file
        wF = Thread(target = writeViveFiles)
        wF.start()
        wF.join()
        
        x = [float(i.split()[0]) for i in control1txt]
        y = [float(i.split()[1]) for i in control1txt]
        z = [float(i.split()[2]) for i in control1txt]

#        plt.figure(figsize = (13,7))
#        plt.subplot(131)
#        plt.plot(x)
#        plt.subplot(132)
#        plt.plot(y)
#        plt.subplot(133)
#        plt.plot(z)
        if 0 in y:
            print("Zeros detected, CHECK PLOT!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
        else:
            print('No zeros detected')
        
        print('Trial Ended')