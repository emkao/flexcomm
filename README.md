# CustomComm

## Description:
CustomComm provides a way for children with cerebral palsy, who are limited by a small range of movements, to communicate with the world. By using a sensor to detect these limited motor movements, children can select a specific option as prompts rotate around the screen. CustomComm allows customizable communication with a lower learning curve. Specifically for Bubba, this app provides a way to communicate with the world using only his current motor abilities, which is moving his left hand. By only using a hardware sensor with an iOS app, CustomComm enables children with varying range of abilities to interact with the world around them. 

## How to Run: 
1. Git clone this repository
2. Open FlexComm.xcodeproj in Xcode 12.4
3. At the top left corner, select iPad Pro (9.7-inch) as device to simulate app on
4. Do Command+R to run the app on the simulated iPad Pro
5. Rotate simulated iPad Pro to run in landscape mode 

## Description  of Provided Functionality: 
CustomComm allows for selection of different buttons through one flex movement, when integrated with expected hardware. When downloading and running this GitHub repository, you will be able to see the functionality of the app without hardware attached.   Solely downloading software allows for the user to see the screen and click through the application; these “clicks'' will be replaced by a flexing movement when the hardware is integrated. 

## Implemented Functionality: 
**On Home Screen:**
- Navigate to Options using "Start" Button 
- Navigate to Settings using "Menu Button 

**On Settings Screen:**
- "Slider Font Size": Change the font size with a slider and then tap "Update Size"

**On Options Screen:**
- "Home" Button to navigate to Home screen
- "Moved Flex Sensor" Button to mimic flex sensor moving through touch
- "Add" Button to add an option to the screen 
- "Edit" Button to edit an existing option on the screen 
- "Delete" Button to delete one or more existing options on the screen 
- "Settings" Button to navigate to Settings screen 
- "Help" Button to call for help (activated by continuous flexing)
- "Back" Button to go to previous screen (activated by 2 flexes)

**Options Customization**
- "Folder": Can make a folder to transition between screens
- "Images": Can add images to options from Camera or Photo Library
- "Icons": Some pre set options come with iconagraphy

