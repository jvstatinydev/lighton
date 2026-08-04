# Get Started with Remote Test Lab for Mobile App Testing | Samsung Developer

Source: https://developer.samsung.com/sdp/blog/en-us/2021/02/18/get-started-with-remote-test-lab-for-mobile-app-testing
Retrieved: 2026-08-04T10:23:56.187Z
HTTP: 200

---

Announcement Mobile

# Get Started with Remote Test Lab for Mobile App Testing

RTL Support
Feb 18, 2021
Remote Test Lab is a service that enables developers to control mobile and watch devices remotely. With the Remote Test Lab service, you can test your application on a real device by interacting with the device over the network in real time.
The Remote Test Lab service is an easy and effective way to comprehensively test your application’s compatibility with the latest Samsung mobile devices, while reducing your spending on test hardware.

## Remote Test Lab highlights

- Application installation
- Screen capture and recording
- Audio streaming
- Repeat testing
- Remote Debug Bridge

## Test applications on a remote real device

In your Web browser, go to Distribute > Remote Test Lab on the Samsung Developer site.
Before using Remote Test Lab, make sure you have the system requirements:
- Samsung Account
- Standard Web browser with JavaScript support
- Java Runtime Environment (JRE) 7 or later, including Java Web Start
- Internet environment with port 2600 outbound open
You can select the operating system, remote device, and testing time you want on the Remote Test Lab page. When you select Start, a JNLP file is downloaded to your computer, and when you run the file, the Remote Test Lab client is launched and the live image of the device screen appears on the client.
You can use the Remote Test Lab device as if it were the real device. For example, you can even zoom in and out on Google Maps using multi-touch.
A variety of testing tools are available in the client context menu:
- Screen menu: Screen Quality Control, Orientation, Scale, Capture and Record, Screen Share
- Manage menu: Application Manager, Clipboard Synchronization, Language, File Manager, Wi-Fi Reset, Device Reboot
- Test menu: Install Application, Auto-Repeat, Log Viewer, Remote Debug Bridge
- Experimental menu: Audio Streaming

|  |  |  |  |
| --- | --- | --- | --- |

For more information on the tools in the context menu, see the User Manual.
You can install your application on the remote device by dragging and dropping the application package from your computer into the Remote Test Lab client. Through the client, you can watch how the application behaves on the device, including in views such as Flex Mode on Galaxy Fold devices.
For more details about the Remote Test Lab service and its policies, see the Remote Test Lab Support.
Next coming up blogs on Remote Test Lab:
- What's new featues on Remote Test Lab
- Loop test with auto-repeat
- Run and test applications with Remote Debug Bridge in Android Studio
- Web-based client preview
.rtl-blue-btn, .rtl-blue-btn:link, .rtl-blue-btn:visited {
    border: 2px solid;
    display: inline-block;
    padding: 8px 16px;
    vertical-align: middle;
    overflow: hidden;
    text-decoration: none;
    color: inherit;
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
3

---

## Figures

**Context Menu > Screen**

Source: https://d3unf4s5rp9dfh.cloudfront.net/SDP_blog/RTL_context_menu.png

**Context Menu > Management**

Source: https://d3unf4s5rp9dfh.cloudfront.net/SDP_blog/RTL_context_menu_manage2.png

**Context Menu > Test**

Source: https://d3unf4s5rp9dfh.cloudfront.net/SDP_blog/RTL_context_menu_test1.png

**Audio Streaming**

Source: https://d3unf4s5rp9dfh.cloudfront.net/SDP_blog/RTL_context_menu_audio_streaming.png


