
          _____                    _____                    _____                  
         /\    \                  /\    \                  /\    \                 
        /::\____\                /::\    \                /::\    \                
       /:::/    /               /::::\    \              /::::\    \               
      /:::/    /               /::::::\    \            /::::::\    \              
     /:::/    /               /:::/\:::\    \          /:::/\:::\    \             
    /:::/____/               /:::/__\:::\    \        /:::/  \:::\    \            
    |::|    |               /::::\   \:::\    \      /:::/    \:::\    \           
    |::|    |     _____    /::::::\   \:::\    \    /:::/    / \:::\    \          
    |::|    |    /\    \  /:::/\:::\   \:::\    \  /:::/    /   \:::\    \         
    |::|    |   /::\____\/:::/  \:::\   \:::\____\/:::/____/     \:::\____\        
    |::|    |  /:::/    /\::/    \:::\  /:::/    /\:::\    \      \::/    /        
    |::|    | /:::/    /  \/____/ \:::\/:::/    /  \:::\    \      \/____/         
    |::|____|/:::/    /            \::::::/    /    \:::\    \                     
    |:::::::::::/    /              \::::/    /      \:::\    \                    
    \::::::::::/____/               /:::/    /        \:::\    \                   
     ~~~~~~~~~~                    /:::/    /          \:::\    \                  
                                  /:::/    /            \:::\    \                 
                                 /:::/    /              \:::\____\                
                                 \::/    /                \::/    /                
                                  \/____/                  \/____/           
# Vive Acquisition Code

**Part of the VAC (Vive/Vicon Acquisition Code) ecosystem.**

This is split into two main parts - a Python script for Vive Acquisition as well as a modified wrapper, and analysis code to find the total rotation and translation. 

*A warning on the analysis code*

The MATLAB code provided uses .mat files that we have internally generated to get world coordinates for the controller. However, it would be perfectly reasonable to either remove these parts or replace it with a separate method to input world coordinates. All that is needed is an nx3 matrix describing XYZ coordinates.

# Setting Up
First, install ```triad_open_VR```. We have provided a modified script that outputs rotation matrices. Controllers will be marked 1 and 2. The first controller is always the one that is first turned on. This can be later validated, but we found that waving the controller before turning on the other ensured that it was controller 1.

*Steps*
1. Ensure Vive system is up and running. The headset and both controllers should be visible to the base stations.
2. Set the variable ```fileName``` to the desired filename.
3. Run the script. Output should appear for the two controllers. 
3. The program will run indefinitely until the loop is broken. To break the loop press ```ctrl-c```. 
4. There should be 4 output files: one rotation and one translation for each controller.

After running the script, a message should appear ensuring that everything went correctly. If something went wrong, two possible messages can appear:
1. A warning that the frame rate was under 200 Hz. If this happens, the script has been overloaded and is not recording properly. Make sure the loop only records the data and nothing else. 
2. A warning that the controller was occluded during play. This is typically just for a few frames. It was crucial that this did not happen during our study, so the warning is pretty dramatic to make sure we saw it. Just repeat the trial if possible, or interpolate the data later. 

Later iterations will have more dynamic updates. 
