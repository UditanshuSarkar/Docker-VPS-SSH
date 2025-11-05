#!/bin/bash
echo "🔐 Starting SSH server..."
service ssh start

echo "🌐 Starting Ngrok TCP tunnel on port 22..."
ngrok tcp 22 --log=stdout
