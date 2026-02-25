# Permissions Setup

Add the following keys in Xcode (target → Info → Custom iOS Target Properties) as needed.

## Camera (for Add Brew photo step)

- **Privacy - Camera Usage Description**
  - Value: `Brewed uses the camera to take a photo of your brew.`

## Location

To enable location services in the Brewed app, you need to add location permission descriptions in Xcode:

## Steps:

1. Open your project in Xcode
2. Select the **Brewed** project in the navigator
3. Select the **Brewed** target
4. Go to the **Info** tab
5. Under "Custom iOS Target Properties", click the **+** button
6. Add the following keys:

   - **Privacy - Location When In Use Usage Description**
     - Value: `Brewed needs your location to show nearby coffee shops and help you discover great coffee experiences.`

   - **Privacy - Location Always and When In Use Usage Description** (optional, if you want background location)
     - Value: `Brewed needs your location to show nearby coffee shops and help you discover great coffee experiences.`

Alternatively, you can add these keys by:
1. Right-clicking in the Info tab
2. Selecting "Add Row"
3. Typing the key name (it will autocomplete)
4. Setting the value

After adding these permissions, the app will be able to request location access and show nearby coffee shops on the map.
