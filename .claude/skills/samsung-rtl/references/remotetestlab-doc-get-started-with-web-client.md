# Get Started with Web Client | Samsung Developer

Source: https://developer.samsung.com/remotetestlab/doc/get-started-with-web-client
Retrieved: 2026-08-04T10:16:59.367Z
HTTP: 200

---

- Remote Test Lab
- Docs
- Guides

# Get Started with Web Client

The Remote Test Lab (RTL) Web Client is a solution that enables you to test your application on real devices by controlling them remotely through a web browser. You can interact with the device in real time and comprehensively test your application before distributing it.
Note:
For more information about the RTL service and its usage policies, see About Remote Test Lab.

## Requirements

To use the RTL Web Client, you must have a Samsung Developer account. The Google Chrome browser is recommended for using the RTL Web Client.

## Launching the RTL Web Client

To start the RTL Web Client, go to the Remote Test Lab web site. The available devices are organized by product line. From the side menu, select the product line for the device you want to test with.
Figure 1. Product page
The product page shows devices from all locations by default. To filter the devices by location, select 1 or more locations from the buttons above the device list. For best performance, select a location geographically close to you.
Figure 2. Device location filter
To search for a specific device model, enter the model name in the Search bar.
Figure 3. Search for a specific model
Alternatively, you can view the devices in list format and use additional search filters by selecting All Devices from the side menu. The available filters include location, display type, model name, OS version, and device name. For example, you can search for foldable devices.
Figure 4. Search within the “All Devices” list
To reserve a device for testing, select the device and OS version you want to test, and define the reservation duration. To begin the testing session, select Start.
Figure 5. Define test device and reservation duration
Note:
You must have sufficient credits to make a reservation. The number of credits required depends on the reservation duration. If you end your session before the full time of your reservation, credits proportional to the unused time are returned to you. For more information about credits, see User Privilege.
The RTL Web Client opens in a new window.
Figure 6. RTL Web Client window
Note:
If you have reserved multiple devices, each device opens within its own tab in the RTL Web Client window.
Figure 7. Multiple device tabs

## RTL Web Client features

The various RTL Web Client features are accessed through the side menu, the settings bar, and the Logs button.
Figure 8. Features in the RTL Web Client interface
The side menu is on the left side of the window and contains features related to managing the device information, applications, and settings:
- Device Information: shows the device details, such as its model, resolution, and OS version.
- Languages: allows you to select the UI language on the device.
- Applications: enables you to manage the applications on the device. You can install, run, stop, and uninstall applications.
- Clipboard: enables you to copy text from the host (your computer) to the device, or from the device to the host.
- File Browser: allows you to manage the files on the device.
- Automated Test: allows you to run predefined tests on applications installed on the device.
- Remote Debug Bridge: enables you to debug your application and manage the device through an ADB connection.
- Audio Out: switches audio streaming through the device on and off.
- Reset Wi-Fi: enables you to manage the wireless Internet connection on the device.
For more information about the side menu features, see Testing with RTL.
From the settings bar to the right of the device screen, you can control the screen view and how you interact with it:
- The Input Mode button is only available for device models that support the S Pen. It switches the input mode between touch and S Pen by triggering the S Pen separate or attach event. Touch input mode is enabled by default.
- The Rotate button changes the orientation of the device. Each click rotates the device 90 degrees counterclockwise.
- The Folding button is available for foldable device models only. It enables you to switch between folded, unfolded, and Flex Mode (partially folded).
- The Screen Quality slider allows you to adjust the quality of the screen image to optimize performance based on your network environment.
The Logs button is below the settings bar and opens the device log.
For more information about the screen settings bar and logs, see Device View.

## Interacting with the device

When the device screen appears in the RTL Web Client, you can interact with the device in the following ways:
- Touch gesture
- Scroll: Scroll with your mouse wheel on the screen.
- Hardware buttons: Click the buttons on the bezel as if on the actual device. You can click only one button at a time.
- Keyboard: Enter alphanumeric characters and simple special symbols from your keyboard.
- S Pen: On devices that support the S Pen, you can also perform various pen events. For more information, see Input Mode.
Note:
If the RTL Web Client becomes unresponsive, right-click the window and select Refresh. Your session remains open and you can continue testing.

## Managing your RTL usage

On the Remote Test Lab page, in the MY TEST LAB side menu section, you can manage and review your device reservations and test results.
To view a list of your active device reservations, select Reservations. If you have time remaining on a reservation, select it to relaunch the Web Client for that device.
Figure 9. Active reservations
If you have completed your testing and no longer need the reservation, hover over the device in the list and select the X button. Credits are returned to you based on the amount of unused time.
Figure 10. Credits returned
To view your RTL device history, select Usage History. The list contains the details of your RTL device usage over the last 3 months.
Figure 11. Usage history list
To review your automated test results, select Automated Test History. For information about the automated test results, see Testing with RTL.
Figure 12. Automated test history list
Note:
The Automated Test History feature is temporarily unavailable.
On This Page
- Requirements
- Launching the RTL Web Client
- RTL Web Client features
- Interacting with the device
- Managing your RTL usage
top of page

---

## Figures

**Figure 1. Product page**

Source: https://developer.samsung.com/remotetestlab/uploads/static/pages/70/GS_1_product_pages.png

**Figure 2. Device location filter**

Source: https://developer.samsung.com/remotetestlab/uploads/static/pages/70/GS_2_device_filter.png

**Figure 3. Search for a specific model**

Source: https://developer.samsung.com/remotetestlab/uploads/static/pages/70/GS_3_search_model.png

**Figure 4. Search within the “All Devices” list**

Source: https://developer.samsung.com/remotetestlab/uploads/static/pages/70/GS_4_all_devices.png

**Figure 5. Define test device and reservation duration**

Source: https://developer.samsung.com/remotetestlab/uploads/static/pages/70/GS_5_define_test.png

**Figure 6. RTL Web Client window**

Source: https://developer.samsung.com/remotetestlab/uploads/static/pages/70/GS_6_client_web.png

**Figure 7. Multiple device tabs**

Source: https://developer.samsung.com/remotetestlab/uploads/static/pages/70/GS_7_multi_devices.png

**Figure 8. Features in the RTL Web Client interface**

Source: https://developer.samsung.com/remotetestlab/uploads/static/pages/70/GS_8_feature.png

**Figure 9. Active reservations**

Source: https://developer.samsung.com/remotetestlab/uploads/static/pages/70/GS_9_active_reservation.png

**Figure 10. Credits returned**

Source: https://developer.samsung.com/remotetestlab/uploads/static/pages/70/GS_10_credits_returned.png

**Figure 11. Usage history list**

Source: https://developer.samsung.com/remotetestlab/uploads/static/pages/70/GS_11_usage_history.png

**Figure 12. Automated test history list**

Source: https://developer.samsung.com/remotetestlab/uploads/static/pages/70/GS_12_automated_history.png


