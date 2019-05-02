
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
First, download the [triad_openvr](https://github.com/TriadSemi/triad_openvr) code from their github page. You will have to install [pyopenvr](https://github.com/cmbruns/pyopenvr). Further instructions for setting up this code is included [here](https://www.roadtovr.com/how-to-use-the-htc-vive-tracker-without-a-vive-headset/). We plan to upload a modified wrapper that outputs the rotation matrix, but currently **this repository is for posterity and version control**. If you want the wrapper to output a rotation matrix, you will have to modify the code yourself. This is because we're not sure how the licensing works on this kind of thing. 

Controllers will be marked 1 and 2. The first controller is always the one that is first turned on. This can be later validated, but we found that waving the controller before turning on the other ensured that it was controller 1.

*Steps*
1. Ensure Vive system is up and running. The headset and both controllers should be visible to the base stations.
2. Set the variable ```trialName``` to the desired filename.
3. Run the script. Output should appear for the two controllers. 
3. The program will run indefinitely until the loop is broken. To break the loop press ```ctrl-c```. 
4. There should be 4 output files: one rotation and one translation for each controller.

After running the script, a message should appear ensuring that everything went correctly. If something went wrong, two possible messages can appear:
1. A warning that the frame rate was under 200 Hz. If this happens, the script has been overloaded and is not recording properly. Make sure the loop only records the data and nothing else. 
2. A warning that the controller was occluded during play. This is typically just for a few frames. It was crucial that this did not happen during our study, so the warning is pretty dramatic to make sure we saw it. Just repeat the trial if possible, or interpolate the data later. 

Later iterations will have more dynamic updates so that fewer adjustments need to be made to get and output data.

# Further Processing
This code is fairly flexible and be accommodated to track several different objects. However, I think that further tracking would be better done in Unity/Unreal Engine, especially when tracking > 2 objects. 
