#!/usr/bin/env bash
set -e

ENV_FILE="${HOME}/.config/transmission-vpn/.env"
SERVICE_NAME="transmission-vpn.service"
WEB_URL="http://localhost:9091"

notify() {
    if command -v notify-send >/dev/null 2>&1; then
        notify-send "Transmission VPN" "$1"
    else
        echo "[Transmission VPN] $1"
    fi
}

check_env() {
    if [ ! -f "$ENV_FILE" ]; then
        notify "Configuration file missing at $ENV_FILE. Please run install.py or setup your .env file."
        exit 1
    fi

    if grep -q "CHANGE_ME_REPLACE_WITH_YOUR_KEY" "$ENV_FILE" || grep -q "your_protonvpn_wireguard_private_key_here" "$ENV_FILE"; then
        notify "Please set your PROTON_PRIVATE_KEY in $ENV_FILE before launching."
        exit 1
    fi
}

start_service() {
    check_env
    notify "Starting Transmission VPN containers..."
    systemctl --user start "$SERVICE_NAME"
}

stop_service() {
    notify "Stopping Transmission VPN containers..."
    systemctl --user stop "$SERVICE_NAME"
    notify "Transmission VPN stopped."
}

wait_and_open_ui() {
    start_service

    notify "Waiting for Transmission Web UI to become available..."
    local retries=30
    local count=0

    while [ $count -lt $retries ]; do
        if curl -s --connect-timeout 2 "$WEB_URL" >/dev/null 2>&1; then
            notify "Transmission Web UI ready. Opening browser..."
            xdg-open "$WEB_URL" >/dev/null 2>&1 &
            return 0
        fi
        sleep 1
        count=$((count + 1))
    done

    notify "Timed out waiting for Transmission Web UI. Check container logs with 'systemctl --user status $SERVICE_NAME' or 'docker logs gluetun'."
}

case "$1" in
    --start)
        start_service
        ;;
    --stop)
        stop_service
        ;;
    --open)
        wait_and_open_ui
        ;;
    *)
        wait_and_open_ui
        ;;
esac
