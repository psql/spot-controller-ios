#!/bin/bash
# Start the Spot Web backend server for iOS app

echo "🤖 Starting Spot Controller Backend..."
echo ""

cd /Users/pasquale/dev/spot-web

# Activate venv
source venv/bin/activate

# Get IP addresses
echo "📡 Server will be accessible at:"
ifconfig | grep "inet " | grep -v 127.0.0.1 | awk '{print "   http://" $2 ":8081"}' | head -2
echo ""

# Start server
echo "🚀 Starting FastAPI server..."
uvicorn backend.app:app --host 0.0.0.0 --port 8081

# Server runs until Ctrl+C
