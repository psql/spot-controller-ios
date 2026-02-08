# Quick Start Guide

## Opening the Project

1. Navigate to the project directory:
   ```bash
   cd /Users/pasquale/dev/SpotController-iOS
   ```

2. Open the project in Xcode:
   ```bash
   open SpotController.xcodeproj
   ```

   Or double-click `SpotController.xcodeproj` in Finder.

## Running the App

### In Simulator

1. In Xcode, select a simulator from the device menu (e.g., "iPhone 15 Pro")
2. Press `⌘R` or click the Play button
3. The app will build and launch in the iOS Simulator

### On a Physical Device

1. Connect your iPhone or iPad via USB
2. Select your device from the device menu
3. If prompted, trust your development certificate on the device
4. Press `⌘R` or click the Play button
5. If this is your first time, you may need to trust the developer certificate:
   - On your device: Settings > General > VPN & Device Management
   - Tap your developer profile and select "Trust"

## Setting Up the Backend

The iOS app requires a FastAPI backend running. You need to:

1. Start your FastAPI backend server:
   ```bash
   cd /Users/pasquale/dev/spot-web  # or wherever your backend is
   uvicorn main:app --host 0.0.0.0 --port 8081
   ```

2. In the iOS app:
   - For **Simulator**: Use `http://localhost:8081`
   - For **Device**: Use `http://YOUR_COMPUTER_IP:8081` (e.g., `http://192.168.1.100:8081`)

3. To find your computer's IP address:
   ```bash
   ipconfig getifaddr en0  # for WiFi
   # or
   ipconfig getifaddr en1  # for Ethernet
   ```

## First Run

1. Launch the app
2. You'll see the Connection screen
3. Enter your backend URL (default: `http://localhost:8081`)
4. Tap "Connect"
5. Once connected, you'll see the main controls

## Testing Without a Robot

You can test the app without an actual Spot robot by creating a mock FastAPI backend:

```python
# mock_backend.py
from fastapi import FastAPI
from pydantic import BaseModel

app = FastAPI()

class GaitRequest(BaseModel):
    gait: str

class PoseRequest(BaseModel):
    yaw: float
    roll: float
    pitch: float

@app.post("/api/connect")
async def connect():
    return {"status": "connected"}

@app.post("/api/disconnect")
async def disconnect():
    return {"status": "disconnected"}

@app.post("/api/power/{action}")
async def power(action: str):
    return {"status": "success"}

@app.post("/api/stand")
async def stand():
    return {"status": "success"}

@app.post("/api/sit")
async def sit():
    return {"status": "success"}

@app.post("/api/estop")
async def estop():
    return {"status": "success"}

@app.post("/api/estop/release")
async def estop_release():
    return {"status": "success"}

@app.post("/api/move/{direction}")
async def move(direction: str):
    print(f"Moving: {direction}")
    return {"status": "success"}

@app.post("/api/gait")
async def set_gait(request: GaitRequest):
    print(f"Setting gait: {request.gait}")
    return {"status": "success"}

@app.post("/api/animation/{name}")
async def animation(name: str):
    print(f"Playing animation: {name}")
    return {"status": "success"}

@app.post("/api/pose")
async def set_pose(request: PoseRequest):
    print(f"Setting pose: yaw={request.yaw}, roll={request.roll}, pitch={request.pitch}")
    return {"status": "success"}

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8081)
```

Run it with:
```bash
pip install fastapi uvicorn
python mock_backend.py
```

## Troubleshooting

### Cannot connect to backend

- **Simulator**: Make sure backend is running on `localhost:8081`
- **Device**:
  - Ensure device and computer are on the same WiFi network
  - Use your computer's local IP address, not `localhost`
  - Check your firewall settings allow incoming connections on port 8081

### Build errors in Xcode

- Clean build folder: `⌘ + Shift + K`
- Delete derived data: Xcode > Preferences > Locations > Derived Data > Click arrow and delete folder
- Restart Xcode

### App crashes on launch

- Check the Xcode console for error messages
- Ensure you're running iOS 16.0 or later
- Try resetting the simulator: Device > Erase All Content and Settings

## Project Structure

```
SpotController-iOS/
├── SpotController.xcodeproj/          # Xcode project (open this)
├── SpotController/
│   ├── SpotControllerApp.swift        # App entry point
│   ├── ContentView.swift              # Root view
│   ├── API.swift                      # Backend API client
│   └── Views/                         # All UI screens
├── README.md                          # Full documentation
├── API_SPEC.md                        # Backend API specification
└── QUICKSTART.md                      # This file
```

## Next Steps

1. Read [API_SPEC.md](API_SPEC.md) to understand the backend requirements
2. Read [README.md](README.md) for full documentation
3. Customize the UI by editing files in `SpotController/Views/`
4. Modify API endpoints by editing `SpotController/API.swift`

## Support

The app is designed to work with:
- iOS 16.0+
- iPhone and iPad
- Portrait and landscape orientations (iPad)
- Light and dark mode

Enjoy controlling your Spot robot!
