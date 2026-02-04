#!/bin/bash
set -e

INSTALL_DIR="/opt/gpio-shutdown"
VENV_DIR="$INSTALL_DIR/venv"
DEFAULT_GPIO=17

if [ "$EUID" -ne 0 ]; then
  echo "Please run as root"
  exit 1
fi

echo
echo "=== Raspberry Pi GPIO Shutdown Setup ==="
echo "BCM GPIO number for shutdown button"
echo "Press ENTER to use default: $DEFAULT_GPIO"
echo

read -rp "GPIO (BCM): " GPIO_PIN
GPIO_PIN="${GPIO_PIN:-$DEFAULT_GPIO}"

if ! [[ "$GPIO_PIN" =~ ^[0-9]+$ ]]; then
  echo "Invalid GPIO number"
  exit 1
fi

echo "Using GPIO $GPIO_PIN"
echo

apt update
apt install -y python3 python3-venv python3-pip

mkdir -p "$INSTALL_DIR"

python3 -m venv "$VENV_DIR"
"$VENV_DIR/bin/pip" install --upgrade pip
"$VENV_DIR/bin/pip" install -r requirements.txt

cp gpio_shutdown.py "$INSTALL_DIR/"
chmod 755 "$INSTALL_DIR/gpio_shutdown.py"

echo "GPIO_PIN=$GPIO_PIN" > "$INSTALL_DIR/env.conf"

cp gpio-shutdown.service /etc/systemd/system/

systemctl daemon-reload
systemctl enable gpio-shutdown.service
systemctl start gpio-shutdown.service

echo
echo "Installation complete."
systemctl status gpio-shutdown.service --no-pager
