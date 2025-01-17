# CustomComm

## Description:
CustomComm provides a way for children with cerebral palsy, who are limited by a small range of movements, to communicate with the world. By using a sensor to detect these limited motor movements, children can select a specific option as prompts rotate around the screen. CustomComm allows customizable communication with a lower learning curve. Specifically for Bubba, this app provides a way to communicate with the world using only his current motor abilities, which is moving his left hand. By only using a hardware sensor with an iOS app, CustomComm enables children with varying range of abilities to interact with the world around them. 

## How to Run: 
**Software**
1. Git clone this repository
2. Open FlexComm.xcodeproj in Xcode 12.4
3. At the top left corner, select iPad Pro (9.7-inch) as device to simulate app on
4. Do Command+R to run the app on the simulated iPad Pro
5. Rotate simulated iPad Pro to run in landscape mode 

**Hardware**
1. Plug battery into the Adafruit Feather 
2. Wear glove 
3. Connect to the app through the Settings screen and calibrate to desired sensitivity

Be cautious and aware that the flex sensor is delicate, so try not to bend it in the wrong direction. The glove should only be worn on the left hand. Sometimes, the flex sensor may not accurately pick up the flexes. Double check to make sure that the center of the flex sensor aligns with where you are bending your wrist. Make sure to calibrate the flex sensor every time you start the application in order to ensure the best accuracy for selection. 

If the flex sensor does break due to use over time, the flex sensor could be bought at https://www.sparkfun.com/products/8606. You will need to use a soldering iron to detach the current flex sensor and attach the new flex sensor. 

## Description  of Provided Functionality: 
CustomComm allows for selection of different buttons through one flex movement, when integrated with expected hardware. When downloading and running this GitHub repository, you will be able to see the functionality of the app without hardware attached.   Solely downloading software allows for the user to see the screen and click through the application; these “clicks'' will be replaced by a flexing movement when the hardware is integrated. 

## Implemented Functionality: 
**On Home Screen:**
- Navigate to Options using "Start" Button 
- Navigate to Settings using "Menu Button 
- Navigate to Intructions with details of how to use the app through the "Instructions" Button

**On Settings Screen:**
- "Slider Font Size": Change the font size with a slider and then tap "Update Size"
- "Response Time": Change the response time to adjust timing for the rotating options within the Options Screen
- "Text to Speech": Toggle for text to voice for the options within the Options Screen
- "Connect to Flex Sensor": Bluetooth connection and calibration of the Flex Sensor

**On Options Screen:**
- "Home" Button to navigate to Home screen
- "Moved Flex Sensor" Button to mimic flex sensor moving through touch
- "Add" Button to add an option to the screen
- "Edit" Button to edit an existing option on the screen 
- "Delete" Button to delete one or more existing options on the screen 
- "Settings" Button to navigate to Settings screen 
- "Help" Button to call for help by playing beeping sound (activated by continuous flexing)
- "Back" Button to go to previous screen (activated by 2 flexes)

**Options Customization**
- "Folder": Can make a folder to transition between screens
- "Images": Can add images to options from Camera or Photo Library
- "Icons": Some pre set options come with iconagraphy

