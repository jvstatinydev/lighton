# Connect to Devices on Remote Test Lab Using RDB in Android Studio | Samsung Developer

Source: https://developer.samsung.com/remote-test-lab/blog/en-us/2022/07/13/connect-to-devices-on-remote-test-lab-using-rdb-in-android-studio
Retrieved: 2026-08-04T10:23:36.013Z
HTTP: 200

---

Tutorials Mobile

# Connect to Devices on Remote Test Lab Using RDB in Android Studio

Remote Debug Bridge
RTL Support
Jul 13, 2022
Remote Debug Bridge
Last year, we released the latest version of Remote Test Lab that supports the new web-based client and provides a user experience comparable with a real device.
Today, we are happy to introduce a new feature, Remote Debug Bridge, that allows application developers to test and debug applications easily by creating an Android Debug Bridge (adb) connection to a real device on the Remote Test Lab in Android Studio.

## What is Remote Debug Bridge?

Remote Debug Bridge (rdb) allows developers to use an Android device provided by the Remote Test Lab service in Android Studio.
If you connect rdb with the web-based Remote Test Lab client, you can see our remote devices in the Android Device Manager and can have the same experience as a physical device connected to your host PC.

## Reserve Android device on Remote Test Lab

To use a remote device, first go to Remote Test Lab.
Remote Test Lab provides over 1500 different devices, ranging from mobile devices, including the latest foldable models, to the newest smart watches.
To use an Android device, click "Galaxy Mobile" on Remote Test Lab and then select one of the devices.
For more information on how to use Remote Test Lab, refer back the previous post:
Test Your Apps in Multiple Regions with the New Web-Based Remote Test Lab

## Run Remote Debug Bridge application

To run rdb, adb is also required.
If you have not installed adb already, you must install it first.
To download the rdb application:
- Launch the Remote Test Lab web-based client and click "Remote Debug Bridge" on the navigation menu.
- Click "Connect" on the menu pop-up.
- Click the "Download" link on the pop-up to download the application to your host PC as a ZIP file.
- Install the rdb application.
Note
Do not close the window running the rdb application while you are using the device with Android Studio.

## Connect remote device

To connect a remote device to your host PC:
- Click the "Connect" button on the "Remote Debug Bridge" menu pop-up.
- If the web-based client shows an RSA dialog on the screen preview, click the "Allow" button.
Note
When you connect to a device running Android 4.2.2 or higher, the system shows a dialog asking whether to accept an RSA key that allows debugging through this computer. This security mechanism protects user devices because it ensures that USB debugging and other adb commands cannot be executed unless you are able to unlock the device and acknowledge the dialog.
Now you are ready to use the device provided by Remote Test Lab.

## Use device in Android Studio

When the connection between the device and your host PC is established, Android Studio shows the device name on the running devices list box. The device is also shown on the "Physical" tab on the Device Manager.
Once the device is connected, you can also run adb commands in the command window or terminal.
If you have any feedback about how we can improve our service, send us a Support Request.
2

---

## Figures

**Figure 1. web-based client with Android Studio**

Source: https://d3unf4s5rp9dfh.cloudfront.net/RemoteTestLab_blog/WebClient_AS_Device2.png?width=900px

**Figure 2. Reserve a device**

Source: https://d3unf4s5rp9dfh.cloudfront.net/RemoteTestLab_blog/RTL_start_web_client.gif?width=900px

**Figure 3. WebClient rdb pop-up**

Source: https://d3unf4s5rp9dfh.cloudfront.net/RemoteTestLab_blog/WebClient_RDB_Popup.png?width=900px

**Figure 4. Web Client RSA dialog**

Source: https://d3unf4s5rp9dfh.cloudfront.net/RemoteTestLab_blog/WebClient_RSA_Dialog.png?width=900px

**Figure 5. Android Device Manager**

Source: https://d3unf4s5rp9dfh.cloudfront.net/RemoteTestLab_blog/AS_WebClient.png?width=900px

**Figure 6. ADB running on the command line**

Source: https://d3unf4s5rp9dfh.cloudfront.net/RemoteTestLab_blog/RDB_WebClient_ADB.png


