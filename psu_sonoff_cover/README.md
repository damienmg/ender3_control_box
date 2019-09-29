# Ender 3 PSU Cover with Sonoff Basic

This is a 3D printable PSU cover for the Creality Ender-3 to also contains a [Sonoff Basic R3](https://www.itead.cc/sonoff-basicr3-wifi-diy-smart-switch.html)
to command the power by WiFi.

A good option is to flash the Sonoff to use [Tasmota](https://github.com/arendst/Sonoff-Tasmota) instead of the native software. Then you can shutdown the printer
when shutting down the linked Octopi by installing the [poweroff service](#power-off-service).

This object can also be found on [Thingiverse](https://www.thingiverse.com/thing:3887024). The mock for the Sonoff can be found on [Thingiverse](https://www.thingiverse.com/thing:3887044) too.

## Poweroff Service

[power_off](power_off) and [power-off.service] files can be used to power off the printer when powering off the Raspberry Pi if you installed [Tasmota](https://github.com/arendst/Sonoff-Tasmota) on your sonoff.

__ATTENTION__: The sonoff needs to be configured without authentication, which is safe, only if the subnetwork you are in is safe. With that setting everybody on the sonoff network can reconfigure the sonoff as well as turn it on/off.

To install this service:

- Install curl: `sudo apt install curl`
- Copy [power_off](power_off) to `/usr/local/bin` and set it to executable: `sudo curl -L https://github.com/damienmg/ender3_control_box/raw/master/psu_sonoff_cover/power_off -o /usr/local/bin/power_off; sudo chmod +x /usr/local/bin/power_off`,
- Copy [power-off.service](power-off.service) to `/etc/systemd/system`: `sudo curl -L https://github.com/damienmg/ender3_control_box/raw/master/psu_sonoff_cover/power-off.service -o /etc/systemd/system/power-off.service`,
- Edit `/usr/local/bin/power_off` (e.g. by `sudo nano /usr/local/bin/power_off`) and replace `ADDR=0.0.0.0` with your Sonoff IP address (e.g. by `ADDR=192.168.42.42`), and
- Setup the service with `systemctl enable power-off`.
