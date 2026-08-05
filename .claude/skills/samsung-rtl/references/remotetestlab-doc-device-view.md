# Device View | Samsung Developer

Source: https://developer.samsung.com/remotetestlab/doc/device-view
Retrieved: 2026-08-04T10:17:52.191Z
HTTP: 200

---

- Remote Test Lab
- Docs
- Guides

# Device View

In the RTL Web Client, the device view consists of the device screen, the Settings bar, and the Logs button.
Figure 1. Settings bar and Logs button
The settings bar enables you to control various elements of the device screen and input method.
- Input Mode switches the input mode between touch and S Pen.
- Rotate changes the orientation of the device.
- Folding switches a foldable device between folded, unfolded, and Flex Mode (partially folded).
- Screen Quality slider adjusts the quality of the device screen image shown in the RTL Web Client.
- Logs opens the device log.

## Input Mode

The Input Mode button is available only on device models that support the S Pen, such as Samsung Galaxy Note models. The button enables you to switch between Touch and S Pen input modes through the RTL Web Client. The mouse cursor changes based on the active input mode.

| Input mode | Mouse cursor |
| --- | --- |
| Touch |  |
| S Pen |  |

Table 1: Input modes
Depending on the input mode, different events can be sent to the remote device. The S Pen input mode includes additional events to handle pen hovering and the side button on the pen.
To send S Pen events to the device through the RTL Web Client, use the following activation keys on your keyboard.

| Event | Mouse cursor | Activation key |
| --- | --- | --- |
| Activated | Deactivated |
| Pen button press |  |  | Ctrl key |
| Pen hover |  |  | Shift key |

Table 2: S Pen input events
For example, to run Action Memo on an actual device, you must double-tap the screen while pressing the S Pen button. To perform the same action through the RTL Web Client, press and hold Ctrl on your keyboard while double-clicking the screen.
Note:
To implement S Pen features in your application, use the S Pen SDK.

## Rotate

To change the screen orientation, click the Rotate button. Each click rotates the device 90 degrees counterclockwise. The default orientation of the screen depends on the device model.

| Original orientation | Rotated 90 degrees counterclockwise |
| --- | --- |
|  |  |

Table 3: Device rotation

## Folding

The Folding button is available for foldable device models only. It enables you to switch the folding state between folded, unfolded, and Flex Mode (partially folded).

| State | Screen settings bar icon | Device image |
| --- | --- | --- |
| Folded |  |  |
| Unfolded |  |  |
| Flex Mode |  |  |

Table 4: Foldable device modes

## Screen Quality

The screen quality slider can be used to adjust the image quality of the device screen displayed in the RTL Web Client. You can decrease the screen quality for better performance or increase the screen quality for higher-resolution images.
Note:
Depending on your network conditions, high-resolution images can cause the RTL Web Client display to run slowly.

| High quality | Medium quality | Low quality |
| --- | --- | --- |
|  |  |  |
|  |  |  |

Table 5: Screen quality

## Logs

This Logs button opens the log from the remote device. You can adjust the width of the Logs window by dragging the left side of the window.
Figure 2. Logs window
The Logs window has the following features:
- Filters enables you to filter the displayed log messages.
- Download enables you to save a copy of the log to your computer.
- Refresh clears the log messages from the window.
To open the log filter popup, select Filter. You can define which details are visible in the log entries by enabling or disabling their checkboxes. For example, to hide the date information, disable the Date checkbox.
Figure 3. Log filters
You can also filter the logs by the following criteria:
- Date and timespan
- Process ID (PID) or thread ID (TID)
- Log priority (Verbose, Debug, Info, Warning, Error, Assert)
Additionally, you can search for specific strings in the Tag and Message fields. Enable the  button to search for exact matches only, and enable the  button to search with case sensitivity.
On This Page
- Input Mode
- Rotate
- Folding
- Screen Quality
- Logs
top of page

---

## Figures

**Figure 1. Settings bar and Logs button**

Source: https://developer.samsung.com/remotetestlab/uploads/static/pages/70/DV_1_setting_bar.png

**img**

Source: https://developer.samsung.com/remotetestlab/uploads/static/pages/70/DV_2_table_3_poitrait.png

**img**

Source: https://developer.samsung.com/remotetestlab/uploads/static/pages/70/DV_2_table_3_landscape.png

**img**

Source: https://developer.samsung.com/remotetestlab/uploads/static/pages/70/DV_3_table_4_folded.png

**img**

Source: https://developer.samsung.com/remotetestlab/uploads/static/pages/70/DV_3_table_4_unfolded.png

**img**

Source: https://developer.samsung.com/remotetestlab/uploads/static/pages/70/DV_6_table_4_flex.png

**img**

Source: https://developer.samsung.com/remotetestlab/uploads/static/pages/70/DV_TB5_1.png

**img**

Source: https://developer.samsung.com/remotetestlab/uploads/static/pages/70/DV_TB5_4.png

**img**

Source: https://developer.samsung.com/remotetestlab/uploads/static/pages/70/DV_TB5_5.png

**img**

Source: https://developer.samsung.com/remotetestlab/uploads/static/pages/70/DV_TB5_6.png

**Figure 2. Logs window**

Source: https://developer.samsung.com/remotetestlab/uploads/static/pages/70/DV_7_log_window.png

**Figure 3. Log filters**

Source: https://developer.samsung.com/remotetestlab/uploads/static/pages/70/DV_8_log_filters.png


