# Spot Controller iOS

A modern SwiftUI iOS application for controlling Boston Dynamics Spot robot via a FastAPI backend.

## Features

- **Connection Management**: Connect to Spot via HTTP backend
- **Power Controls**: Power Spot on/off
- **Stance Controls**: Make Spot stand or sit
- **Movement Controls**: Control Spot's movement (forward, backward, left, right)
- **Gait Selection**: Choose different movement gaits (Auto, Walk, Trot, Crawl, Amble)
- **Animation Controls**: Perform pre-built animations and custom poses
- **Emergency Stop**: Quick access to E-Stop functionality

## Requirements

- iOS 16.0 or later
- Xcode 15.0 or later
- Swift 5.9 or later
- FastAPI backend running at http://localhost:8081 (or custom URL)

## Project Structure

```
SpotController-iOS/
├── SpotController.xcodeproj/          # Xcode project file
│   ├── project.pbxproj
│   └── project.xcworkspace/
├── SpotController/
│   ├── SpotControllerApp.swift        # App entry point
│   ├── ContentView.swift              # Main view controller
│   ├── API.swift                      # Backend communication
│   ├── Views/
│   │   ├── ConnectionView.swift       # Connection screen
│   │   ├── ControlsView.swift         # Main controls UI
│   │   ├── GaitSelectionView.swift    # Gait selection UI
│   │   └── AnimationControlsView.swift # Animation controls UI
│   ├── Assets.xcassets/               # App icons and colors
│   ├── Info.plist                     # App configuration
│   └── Preview Content/               # SwiftUI preview assets
└── README.md
```

## Installation

1. Open `SpotController.xcodeproj` in Xcode
2. Select your target device (iPhone or iPad)
3. Click Run (⌘R) to build and launch the app

## Usage

### Connecting to Spot

1. Launch the app
2. Enter your backend server URL (default: http://localhost:8081)
3. Tap "Connect"

### Main Controls

- **Power On/Off**: Control Spot's power state
- **Stand/Sit**: Control Spot's stance
- **Movement**: Use arrow buttons to move Spot (forward, backward, left, right)
- **Emergency Stop**: Red button to immediately stop Spot

### Gait Selection

1. Switch to the "Gait" tab
2. Select desired gait from the picker
3. Tap "Apply Gait" to change Spot's movement style

### Animations

1. Switch to the "Animations" tab
2. Tap any animation button to perform pre-built animations
3. Use sliders to create custom poses (yaw, roll, pitch)
4. Tap "Apply Pose" to execute the custom pose

## API Endpoints

The app expects the following FastAPI backend endpoints at `http://localhost:8081`:

- `POST /api/connect` - Connect to Spot
- `POST /api/disconnect` - Disconnect from Spot
- `POST /api/power/on` - Power on Spot
- `POST /api/power/off` - Power off Spot
- `POST /api/stand` - Make Spot stand
- `POST /api/sit` - Make Spot sit
- `POST /api/estop` - Trigger emergency stop
- `POST /api/estop/release` - Release emergency stop
- `POST /api/move/{direction}` - Move Spot (forward, backward, left, right, stop)
- `POST /api/gait` - Set gait type (body: {"gait": "walk"})
- `POST /api/animation/{name}` - Play animation
- `POST /api/pose` - Set custom pose (body: {"yaw": 0.0, "roll": 0.0, "pitch": 0.0})

## Configuration

The app uses HTTP by default for local development. The Info.plist is configured to allow:
- Local networking
- Arbitrary loads (for development)

For production, update the Info.plist to use HTTPS and remove `NSAllowsArbitraryLoads`.

## Development

### Building

```bash
# Open in Xcode
open SpotController.xcodeproj

# Or build from command line
xcodebuild -project SpotController.xcodeproj -scheme SpotController -sdk iphoneos
```

### Testing

The app includes SwiftUI Previews for rapid UI development. Use Xcode's preview canvas to see changes in real-time.

## Notes

- The app requires a running FastAPI backend to function
- Make sure your iOS device and backend server are on the same network
- For simulator testing, use `http://localhost:8081`
- For device testing, use your computer's local IP address

## License

Created for Spot robot control purposes.
