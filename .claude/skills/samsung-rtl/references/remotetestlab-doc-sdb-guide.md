# SDB Guide | Samsung Developer

Source: https://developer.samsung.com/remotetestlab/doc/sdb-guide
Retrieved: 2026-08-04T10:18:03.432Z
HTTP: 200

---

- Remote Test Lab
- Docs
- Remote Test Lab for TV

# How to use Smart Development Bridge (SDB) in RTL TV

RTL TV is using sdbproxy when connecting SDB to the RTL TV target. sdbproxy is required to be installed in your host personal computers.

## Prerequisites


### Operating Systems


|  | Windows | macOS | Ubuntu |
| --- | --- | --- | --- |
| Build Version | 10 | 11 (Big Sur) / 12 (Monterey) | 18.04 / 20.04 |
| Bit | 64 | 64 | 64 |
| Note |  |  | xdg-utils required - xdg-mime is used for custom scheme |
| Extension Downloads | Download | Download | Download |


### Required Software

- Tizen Studio: https://developer.samsung.com/smarttv/develop/getting-started/setting-up-sdk/installing-tv-sdk.html

## Setting up sdbproxy with Tizen Studio

To set up sdbproxy with Tizen Studio:
- Launch the Package Manager
- Click the configuration button  in the Package Manager
- In the Configuration dialog box, scroll down to the Extension SDK panel, or click the Extension SDK  button icon to unfold it
- Click + above the repository information table
- Enter values to the Name and Repository fields in the Add Repository dialog box
- Click OK
- In the Configuration dialog box, check the detailed repository information below the table
- Click OK to confirm
- Click Extension SDK Tab in Package Manager
- Click Install button for RTL TV Tools

## How to use SDB in RTL TV

To use SDB in RTL TV:
- Click the SDB button in RTL TV
- Agree to use sdbproxy in browser confirmations
- sdbproxy will be launched in terminals
- Type in proxy server information if you are in proxy server environments, or just press Enter to skip it
- SDB will be connected with a RTL TV target through sdbproxy

## Troubleshooting


### Failed to install RTL TV Tools in Ubuntu

- Install xdg-utils.

### Terminals are not showing up when the SDB button is clicked

If terminals do not appear from browsers in some system environments, you can set a proxy server setting file manually by editing the proxy.json file.
proxy.json Settings:
- proxy_server: Put proxy server without protocols (e.g., 123.123.123.123:8080), or leave empty ("")
- manual_setting: Put true value
File Location:
- Windows: {user folder}\AppData\Local\sdbproxy\proxy.json
- Ubuntu & Mac: ~/.sdbproxy/proxy.json
On This Page
- Prerequisites
- Setting up sdbproxy with Tizen Studio
- How to use SDB in RTL TV
- Troubleshooting
top of page

---

## Figures

**(untitled)**

Source: https://developer.samsung.com/remotetestlab/uploads/static/pages/sdb-guide/advanced_conf_add_extra.png

**(untitled)**

Source: https://developer.samsung.com/remotetestlab/uploads/static/pages/sdb-guide/package_manager.png

**(untitled)**

Source: https://developer.samsung.com/smarttv/file/1a8b0e84-0b85-4634-9ea5-e034daff64a0


