# Remote Test Lab: Testing Your App with Auto Repeat | Samsung Developer

Source: https://developer.samsung.com/sdp/blog/en-us/2021/04/15/remote-test-lab-testing-your-app-with-auto-repeat
Retrieved: 2026-08-04T10:24:16.345Z
HTTP: 200

---

Tutorials Mobile

# Remote Test Lab: Testing Your App with Auto Repeat

RTL Support
Apr 15, 2021
This blog is the third in a series of posts about Remote Test Lab. In previous blogs, we covered what is Remote Test Lab and its new features. Next, we are going to take a deep dive into some useful features of Remote Test Lab.
The Remote Test Lab service lets you install and test your applications on real devices. In this blog, we are going to install an application and test it on Remote Test Lab devices with Auto Repeat. Auto Repeat is a tool that lets you create a test scenario automatically, repeat the same test several times, and reuse the test later.
Information:
The Auto Repeat feature is supported on a Java-based client only.

## Install your application

To get started, launch a Remote Test Lab client, then go to Remote Test Lab and reserve one of the available mobile devices.
You can install your application on the remote device by dragging and dropping the application package from your computer into the Remote Test Lab client. Through the client, you can watch how the application behaves on the device.
You can also install applications by going to Management > Application Manager or selecting Test > Install Application in the device context menu.
Install your application in any of the ways described above.

### Record and play events

Recording and playing back events is one of the ways to test your applications automatically. When you record events for repeated testing, we recommend that you start and finish recording at the same screen on the Remote Test Lab client.
The following figure shows the most commonly used buttons in the Auto-Repeat window.


① The Add button lets you add more actions manually.
② The Record button starts recording actions on your device screen.
③ The Play button starts playing a test.
④ The Stop button stops playing a test.
To start recording a test scenario, proceed as follows:
- Click Test > Auto Repeat in the context menu on the Remote Test Lab client.
- In the Auto Repeat window, click the Record button.
- Click the Stop button when you want to stop recording.
- To run the test repeatedly, enter a number into the Test Repeat field in the Test Option section.
- Click the Play button.
- Click File > Save.
The following video shows each step of recording events and playing back the test procedure.

### Create test sequences manually

You can also create a test scenario by adding events manually. This method can be more complicated but it lets you insert a wide variety of events to your scenario.
To add an event to your test scenario, proceed as follows:
- Click the add button in the Auto Repeat window.
- Select a desired event.
- Fill in the related information in the Event Properties section.
- Click the Play button.
The following video shows each step of adding events manually.
You can create complete test scenarios by recording events or manually add more events to make the test scenarios more sophisticated.
Remote Test Lab article series
- Get Started with Remote Test Lab for Mobile App Testing
- What's New in Remote Test Lab
- Run and test applications with Remote Debug Bridge in Android Studio (coming soon)
- Web-Based client preview (coming soon)
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
1

---

## Figures

**Auto Repeat**

Source: https://d3unf4s5rp9dfh.cloudfront.net/SDP_blog/rtl_auto_repeat_window_button.png


