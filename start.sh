#!/bin/bash
echo "🔐 Starting SSH server..."
service ssh start

echo "🌐 Starting Ngrok TCP tunnel on port 22..."
ngrok tcp 22 --log=stdout &
sleep 5

echo "📡 Fetching Ngrok public URL..."
curl -s localhost:4040/api/tunnels | grep -o 'tcp://[0-9a-zA-Z\.:]*'
wait
