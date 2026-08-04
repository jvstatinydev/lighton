# Tests on Devices | Samsung Developer

Source: https://developer.samsung.com/remotetestlab/doc/tests-on-devices
Retrieved: 2026-08-04T10:17:26.945Z
HTTP: 200

---

- Remote Test Lab
- Docs
- Guides

# Tests on Devices

In the RTL Web Client, the side menu contains features related to managing the device information, applications, and settings.
Figure 1: RTL Web Client side menu
Selecting a side menu item opens its panel, if it has one. To keep a panel open on the screen, switch the panel to floating mode by selecting the  button. You can then move the panel around within the RTL Web Client by dragging its title bar.
Figure 2: Device Information panel in floating mode
To close a panel in floating mode, select the X button.

## Device Information

The Device Information panel shows the device details, such as its model, Firmware version, screen resolution, OS version, and other Android developer information.
Figure 3: Device Information panel

## Languages

The Languages panel allows you to easily set the device UI language without using the Settings application on the device.

## Applications

The Applications panel enables you to manage the applications on the device.
To sort the application list in ascending or descending order by name, select the column header.
To manage a specific application, select it from the list.
Figure 4: Applications panel
The Applications panel has the following buttons:
- Install App allows you to browse for and select an APK file from your computer to be installed on the device. You can also install an APK file by dragging and dropping it from your computer to the device screen in the RTL Web Client.
- Uninstall removes the selected application from the device.
- Start runs the selected application.
- Stop ends the process for the selected application. The device returns to its home screen.
- Refresh reloads the application list.

## Clipboard

The Clipboard panel allows you to copy clipboard content between the host (your computer) and the device (the remote device).
Note:
The clipboard feature in RTL Web Client supports text content only.
Figure 5: Clipboard panel
You can copy text to and from your computer and the device:
- To send text to the device clipboard from your computer, select Host to Device. The text is sent to the clipboard on the device and you can paste it where it is needed.
- To send text to your computer from the device, select the text you want to send, then select Device to Host. Select the notification that appears on the device screen. The text is sent to the clipboard on your computer and you can paste it where it is needed.
Figure 6: Clipboard notification on the device

## File Browser

The File Browser feature allows you to manage the accessible files and folders on the device. You can also transfer files between your computer and the device.
Figure 7: File Browser panel
To manage the files on the device:
- To download, rename, or remove a file or folder, select the Download, Rename, or Remove button next to its name.
- To upload a file from your computer to the device, navigate to the location on the device, and select Upload.
- To create a folder, navigate to the location on the device, and select Create.

## Automated Test

Note:
The Automated Test feature is temporarily unavailable.
The Automated Test feature enables you to run predefined tests on your applications. The test results provide data on your application performance.
Figure 12: Automated Test panel
To test an application, define the test duration (from 5 to 10 minutes), select the application you want to test, and select Start. During the test you can view the device logs but cannot interact with the device.
To stop the test before the defined duration, select Stop.
When the automated test ends, to view the test result report, select Show Result. The report opens in a new browser tab. In the report, you can review the device information, CPU and memory usage, and screenshots from the test.
Note:
To run an automated test, you must have at least 15 minutes remaining in your reservation time.
If the test is stopped before 5 minutes have elapsed, test results are not generated.
Figure 13: Automated Test result

## Remote Debug Bridge

The Remote Debug Bridge enables you to create an ADB connection from your computer to the remote device. You can use the connection to test your application on the device using development tools, such as Android Studio.
Figure 14: Remote Debug Bridge panel
To use the Remote Debug Bridge:
- On your computer, make sure that your ADB path has been added to the environment variables.
- From the command line on your computer, run the RDB application.
- In the RTL Web Client Remote Debug Bridge panel, select Connect.
- On the remote device, when asked to allow USB debugging, select Allow. Your computer connects to the device and you can send ADB commands to it.

## Audio Out

The Audio Out feature enables you to hear the audio being played through the device.
To begin streaming, in the RTL Web Client, select Audio Out, then confirm on the device by selecting Start now.
Figure 16: Confirm streaming from device
To stop streaming audio from the device, select Audio Out again.

## Reset Wi-Fi

The Reset Wi-Fi feature allows you to reset the Wi-Fi settings on the device. Devices in the RTL are connected to dedicated wireless networks.
To disconnect and reconnect to the wireless network, select Reset Wi-Fi, then select Confirm.
Figure 17: Reset Wi-Fi feature
On This Page
- Device Information
- Languages
- Applications
- Clipboard
- File Browser
- Automated Test
- Remote Debug Bridge
- Audio Out
- Reset Wi-Fi
top of page

---

## Figures

**Figure 1: RTL Web Client side menu**

Source: https://developer.samsung.com/remotetestlab/uploads/static/pages/70/TOD_1_web_client.png

**Figure 2: Device Information panel in floating mode**

Source: https://developer.samsung.com/remotetestlab/uploads/static/pages/70/TOD_2_device_information.png

**Figure 3: Device Information panel**

Source: https://developer.samsung.com/remotetestlab/uploads/static/pages/70/TOD_3_panel.png

**Figure 4: Applications panel**

Source: https://developer.samsung.com/remotetestlab/uploads/static/pages/70/TOD_4_applicaion_panel.png

**Figure 5: Clipboard panel**

Source: https://developer.samsung.com/remotetestlab/uploads/static/pages/70/TOD_5_clipboard.png

**Figure 6: Clipboard notification on the device**

Source: https://developer.samsung.com/remotetestlab/uploads/static/pages/70/TOD_6_clipboard_notification.png

**Figure 7: File Browser panel**

Source: https://developer.samsung.com/remotetestlab/uploads/static/pages/70/TOD_7_file_browser.png

**Figure 8: Download a file**

Source: https://developer.samsung.com/remotetestlab/uploads/static/pages/70/TOD_8_download_file.png

**Figure 9: Upload a file**

Source: https://developer.samsung.com/remotetestlab/uploads/static/pages/70/TOD_9_upload_file.png

**Figure 10: Install an application from an uploaded file**

Source: https://developer.samsung.com/remotetestlab/uploads/static/pages/70/TOD_10_install_application.png

**Figure 11: Create a folder**

Source: https://developer.samsung.com/remotetestlab/uploads/static/pages/70/TOD_11_create_folder.png

**Figure 12: Automated Test panel**

Source: https://developer.samsung.com/remotetestlab/uploads/static/pages/70/TOD_12_automated_test.png

**Figure 13: Automated Test result**

Source: https://developer.samsung.com/remotetestlab/uploads/static/pages/70/TOD_13_automated_test_result.png

**Figure 14: Remote Debug Bridge panel**

Source: https://developer.samsung.com/remotetestlab/uploads/static/pages/70/TOD_14_remote_debug.png

**Figure 15: Remote Debug Bridge connected**

Source: https://developer.samsung.com/remotetestlab/uploads/static/pages/70/TOD_15_remote_debug_connected.png

**Figure 16: Confirm streaming from device**

Source: https://developer.samsung.com/remotetestlab/uploads/static/pages/70/TOD_16_audio_streaming.png

**Figure 17: Reset Wi-Fi feature**

Source: https://developer.samsung.com/remotetestlab/uploads/static/pages/70/TOD_17_reset_wifi.png


