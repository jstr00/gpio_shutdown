#!/usr/bin/env python3

import RPi.GPIO as GPIO
import time
import subprocess
import os
import signal
import sys

BUTTON_GPIO = int(os.environ.get("GPIO_PIN", "17"))
LONG_PRESS_SEC = 2
SHUTDOWN_DELAY = 5

def cleanup_and_exit(signum=None, frame=None):
    GPIO.cleanup()
    sys.exit(0)

signal.signal(signal.SIGTERM, cleanup_and_exit)
signal.signal(signal.SIGINT, cleanup_and_exit)

GPIO.setmode(GPIO.BCM)
GPIO.setup(BUTTON_GPIO, GPIO.IN, pull_up_down=GPIO.PUD_UP)

def shutdown():
    msg = (
        "Shutting down services was triggered.\n"
        f"Shutting down in {SHUTDOWN_DELAY} seconds."
    )
    subprocess.run(["wall", msg], check=False)
    time.sleep(SHUTDOWN_DELAY)
    subprocess.run(["/sbin/shutdown", "-h", "now"], check=False)

while True: # Polling-Loop
    if GPIO.input(BUTTON_GPIO) == GPIO.LOW:
        start = time.time()
        while GPIO.input(BUTTON_GPIO) == GPIO.LOW:
            time.sleep(0.01)
            if time.time() - start >= LONG_PRESS_SEC:
                shutdown()
                cleanup_and_exit()
    else:
        time.sleep(0.05)