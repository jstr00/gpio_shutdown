#!/bin/bash
set -e

SERVICE_NAME="gpio-shutdown"
INSTALL_DIR="/opt/gpio-shutdown"

if [ "$EUID" -ne 0 ]; then
  echo "Please run as root"
  exit 1
fi

echo "Stopping systemd service..."
systemctl stop "$SERVICE_NAME.service" 2>/dev/null || true
systemctl disable "$SERVICE_NAME.service" 2>/dev/null || true

echo "Removing systemd service file..."
rm /etc/systemd/system/"$SERVICE_NAME.service"

echo "Reloading systemd daemon..."
systemctl daemon-reload

if [ -d "$INSTALL_DIR" ]; then
    echo "Removing installation directory $INSTALL_DIR..."
    rm -r "$INSTALL_DIR"
fi

echo "Uninstall complete."
