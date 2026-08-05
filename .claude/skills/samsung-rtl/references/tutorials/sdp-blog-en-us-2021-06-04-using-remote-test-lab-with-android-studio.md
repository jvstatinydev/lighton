# Using Remote Test Lab with Android Studio | Samsung Developer

Source: https://developer.samsung.com/sdp/blog/en-us/2021/06/04/using-remote-test-lab-with-android-studio
Retrieved: 2026-08-04T10:23:46.534Z
HTTP: 200

---

Tutorials Mobile

# Using Remote Test Lab with Android Studio

RTL Support
Jun 4, 2021
This blog is the fourth in a series of posts about Remote Test Lab (RTL). In previous blogs, we covered what is Remote Test Lab, its new features, and Auto Repeat. In this blog, we show you how to connect RTL to Android Studio and how to deploy and debug your app on the remote device. In an upcoming blog, we are going to take a deep dive into some additional features of Remote Test Lab.
Remote Test Lab allows you to run and debug your application on real devices remotely. In this blog, we will connect a Remote Test Lab device with a local development machine’s ADB (Android Debug Bridge) using Remote Debug Bridge.
The Remote Debug Bridge tool enables you to run and debug your app to check compatibility with the latest Samsung mobile devices, which solves the problem of not having your own physical devices.

## Connect your Remote Test Lab device to Android Studio

To get started, launch a Remote Test Lab client, then go to Remote Test Lab and reserve one of the available mobile devices.
The operating system version, device location, and desired time can be selected on the Remote Test Lab page. A JNLP file is downloaded to your computer when you click the Start button. If you run this file, the Remote Test Lab client is launched and a live image of the device is shown in the client.
Step 1. When the live image is shown, right-click on the device's screen and select ‘Test > Remote Debug Bridge.’
Step 2. In the pop-up window, view the required command and port number to connect your Android Studio to the Remote Test Lab device.
Step 3. Open a Command Prompt window and run the ADB command with the given port number. In this example, the command is:
adb connect localhost:50964
Note: You must accept the RSA key prompt by allowing USB debugging when you run the ADB connect command for the first time on a Remote Test Lab device.

## Deploy and debug apps from Android Studio

Step 1. The device is now ready to deploy your app from Android Studio. Build and run your app from Android Studio. In the following screenshot, an app is being deployed on a Remote Test Lab device from Android Studio.
Step 2. The app is deployed and launched successfully on the Remote Test Lab device
Step 3. Debug your app from Android Studio just like on a real device.
In conclusion, Remote Test Lab offers a convenient and effective way to check the compatibility of your app and use debug facilities. Finally, our developer forum is an excellent way to stay up-to-date on all things related to the Samsung Galaxy ecosystem.
Remote Test Lab article series
- Get Started with Remote Test Lab for Mobile App Testing
- What's New in Remote Test Lab
- Testing Your App with Auto Repeat
- Using Remote Test Lab with Android Studio
- Web-Based client preview (coming soon)
.rtl-blue-btn, .rtl-blue-btn:link, .rtl-blue-btn:visited {
    border: 2px solid;
    display: inline-block;
    padding: 8px 16px;
    vertical-align: middle;
    overflow: hidden;
    text-decoration: none;
    color: #1428A0;
    background-color: inherit;
    text-align: center;
    cursor: pointer;
    white-space: nowrap;
    background-color: #FFFFFF;
    border-color: #1428A0;
    transition: background-color .5s;
    border-radius: 6px;
}

 .rtl-blue-btn:hover {
    border-radius: 6px;
    color: #fff!important;
    background-color: #1428A0!important;
}
Go to Remote Test Lab
0

---

## Figures

**Text**

Source: https://d3unf4s5rp9dfh.cloudfront.net/SDP_blog/2021-06-01-01-01.png

**Text**

Source: https://d3unf4s5rp9dfh.cloudfront.net/SDP_blog/2021-06-01-01-02.png

**Text**

Source: https://d3unf4s5rp9dfh.cloudfront.net/SDP_blog/2021-06-01-01-03.png

**Text**

Source: https://d3unf4s5rp9dfh.cloudfront.net/SDP_blog/2021-06-01-01-04_v2.png

**Text**

Source: https://d3unf4s5rp9dfh.cloudfront.net/SDP_blog/2021-06-01-01-05_v2.png

**Text**

Source: https://d3unf4s5rp9dfh.cloudfront.net/SDP_blog/2021-06-01-01-06_v2.png


