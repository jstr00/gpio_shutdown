# Raspberry Pi GPIO Shutdown Button 

Graceful shutdown via GPIO button using a systemd service.
Runs fully isolated in a Python virtual environment.
DEFAULT is GPIO 17. But choose your own

## Features
* Long press (2s) protection
* GPIO selectable during install (GUI)
* SSH/TTY notification via wall
* systemd managed

## Requirements

### Hardware
* Raspberry Pi 4B
* Momentary push button
* GPIO (BCM) -> Button -> GND

### Software
* Python >= 3.8 (Lower not tested)

## Install
```bash
git clone git@github.com:jstr00/gpio_shutdown.git
cd gpio_shutdown
chmod +x install.sh
sudo ./install.sh
```


## Background / Motivation

Raspberry Pi systems are often powered off by simply cutting the power
(e.g. unplugging the power supply or switching off a power strip).

Since the root filesystem typically resides on an **SD card**, and Linux:
* buffers write operations
* commits filesystem metadata asynchronously
* cannot fully protect against sudden power loss even with journaling

an **unclean shutdown** frequently results in:
* filesystem corruption
* inconsistent inodes
* corrupted SQLite or log files
* in the worst case: an **unbootable system**

This is especially problematic for headless setups or embedded deployments
where no keyboard or display is attached and there is **no convenient way to
trigger a graceful shutdown**.

A physical shutdown button provides:
* a reliable and user-independent shutdown mechanism
* a **graceful systemd-managed shutdown**
* clear notification to active SSH/TTY sessions before shutdown


## Disclaimer

This project is provided **as-is**, without any warranties or guarantees of any kind.

The author assumes **no responsibility or liability** for:
- data loss
- hardware damage
- filesystem corruption
- system misconfiguration
- unexpected shutdown behavior

Use this software **at your own risk**.

Always test the setup in a non-critical environment before deploying it
on systems where data integrity or availability matters.
