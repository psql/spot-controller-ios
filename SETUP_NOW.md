# Quick Setup - Get Running in 5 Minutes

## Backend is Already Running!

The FastAPI backend is running at: **http://192.168.100.245:8081**

## Steps to Run on iPhone:

### 1. Open Xcode Project

Already open, or run:
```bash
open /Users/pasquale/dev/SpotController-iOS/SpotController.xcodeproj
```

### 2. Configure Signing

In Xcode:
1. Click "SpotController" in left sidebar (blue icon at top)
2. Select "Signing & Capabilities" tab
3. Check "Automatically manage signing"
4. Select your Team (Apple ID)

### 3. Connect iPhone

1. Plug iPhone into Mac via USB cable
2. Unlock iPhone
3. Trust computer if prompted
4. In Xcode: Select your iPhone from device dropdown (top center, next to "SpotController")

### 4. Build & Run

- Press ⌘R or click ▶ Play button
- App builds (may take 1-2 minutes first time)
- Installs on iPhone
- Launches automatically!

### 5. Connect to Spot

**In the iOS app on your iPhone:**

1. **Server URL field**: Enter `http://192.168.100.245:8081`
   - (Or your Mac's IP from same WiFi as iPhone)

2. **Tap "Connect"**

3. **Control Spot!**
   - Tap "Stand" button
   - Use movement controls
   - Try gaits and animations!

## Important: Network Setup

**Your iPhone and Mac must be on same WiFi network!**

**Option A: Both on Spot's WiFi**
- Connect Mac to Spot WiFi
- Connect iPhone to Spot WiFi
- Use Spot WiFi IP in app

**Option B: Both on your home WiFi**
- Mac on home WiFi (192.168.100.245)
- iPhone on same home WiFi
- Spot in client mode on same WiFi

## Troubleshooting

### "Cannot connect to server"

**Check Mac IP from iPhone:**
- In iPhone Safari: go to `http://192.168.100.245:8081/api/health`
- Should see JSON response
- If not, Mac firewall is blocking

**Fix Mac Firewall:**
- System Settings → Network → Firewall → Options
- Allow Python/uvicorn
- Or disable firewall temporarily for testing

### "Untrusted Developer"

First time installing:
- iPhone Settings → General → VPN & Device Management
- Trust your developer profile
- Go back to app, launch again

## Quick Test

**Once app is running on iPhone:**

1. Tap "Connect" (should succeed if backend running)
2. Tap "Power On"
3. Tap "Stand"
4. **Spot stands up!** ✅

You're controlling Spot from iPhone! 🎉

## Next: Starting Backend Easily

Create this script on Mac for easy startup:

```bash
cat > ~/start-spot-backend.sh << 'SCRIPT'
#!/bin/bash
cd /Users/pasquale/dev/spot-web
source venv/bin/activate
uvicorn backend.app:app --host 0.0.0.0 --port 8081
SCRIPT

chmod +x ~/start-spot-backend.sh
```

Then just: `~/start-spot-backend.sh`

---

**Everything is ready - just open Xcode and click Run!** 📱🤖
