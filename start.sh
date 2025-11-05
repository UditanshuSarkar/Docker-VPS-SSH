#!/bin/bash
echo "🔐 Starting SSH server..."
service ssh start

echo "🌐 Starting Playit.gg tunnel for port 22..."
/usr/local/bin/playit &
sleep 5

echo "📡 Checking Playit status..."
ps aux | grep playit

echo "✅ SSH is ready. Use your Playit.gg dashboard to get your public tunnel address."
wait
