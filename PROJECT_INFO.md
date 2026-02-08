# Project Information

## Project Details

- **Project Name**: SpotController
- **Bundle Identifier**: com.spotcontroller.app
- **Platform**: iOS
- **Deployment Target**: iOS 16.0+
- **Language**: Swift 5.0
- **UI Framework**: SwiftUI
- **Architecture**: MVVM (Model-View-ViewModel)

## Build Information

- **Xcode Version**: 15.0+
- **Swift Version**: 5.9+
- **Build Configuration**: Debug / Release
- **Supported Devices**: iPhone, iPad

## File Overview

### Core Files

| File | Purpose | Lines |
|------|---------|-------|
| `SpotControllerApp.swift` | App entry point with @main | ~15 |
| `ContentView.swift` | Root view, manages connection state | ~25 |
| `API.swift` | Backend communication layer | ~240 |

### View Files

| File | Purpose | Features |
|------|---------|----------|
| `ConnectionView.swift` | Initial connection screen | Server URL input, connection status |
| `ControlsView.swift` | Main robot controls | Power, stance, movement, emergency stop |
| `GaitSelectionView.swift` | Gait selection interface | 5 gait types with descriptions |
| `AnimationControlsView.swift` | Animations and poses | 6 animations, custom pose controls |

### Configuration Files

| File | Purpose |
|------|---------|
| `Info.plist` | App configuration, permissions |
| `project.pbxproj` | Xcode project configuration |
| `Assets.xcassets/` | App icons and colors |

## API Integration

### Backend URL Configuration

The default backend URL is set in `API.swift`:
```swift
@Published var baseURL: String = "http://localhost:8081"
```

To change the default:
1. Open `SpotController/API.swift`
2. Modify line ~18: `@Published var baseURL: String = "YOUR_URL"`

### Network Security

The app allows HTTP connections for local development via Info.plist:
```xml
<key>NSAppTransportSecurity</key>
<dict>
    <key>NSAllowsLocalNetworking</key>
    <true/>
    <key>NSAllowsArbitraryLoads</key>
    <true/>
</dict>
```

**For production**: Remove `NSAllowsArbitraryLoads` and use HTTPS only.

## UI Customization

### Colors

Accent color is defined in `Assets.xcassets/AccentColor.colorset/Contents.json`

Control button colors in `ControlsView.swift`:
- Power On: Green
- Power Off: Orange
- Stand: Blue
- Sit: Purple
- Movement: Blue
- Emergency Stop: Red

### Icons

The app uses SF Symbols for all icons:
- `antenna.radiowaves.left.and.right` - Connection
- `power` - Power control
- `figure.stand` - Stand
- `figure.walk` - Sit
- `arrow.up/down/left/right` - Movement
- `exclamationmark.octagon.fill` - Emergency stop
- `sparkles` - Animations

To change icons, modify the `systemName` parameters in View files.

## State Management

The app uses SwiftUI's `@StateObject` and `@ObservedObject` for state management:

```swift
@StateObject private var api = SpotAPI()  // Root view
@ObservedObject var api: SpotAPI          // Child views
```

Key published properties in `SpotAPI`:
- `isAuthenticated: Bool` - Connection status
- `isPowered: Bool` - Power state
- `isStanding: Bool` - Stance state
- `errorMessage: String` - Error messages

## Building for Distribution

### Debug Build
```bash
xcodebuild -project SpotController.xcodeproj \
  -scheme SpotController \
  -configuration Debug \
  -sdk iphoneos
```

### Release Build
```bash
xcodebuild -project SpotController.xcodeproj \
  -scheme SpotController \
  -configuration Release \
  -sdk iphoneos \
  -archivePath ./build/SpotController.xcarchive \
  archive
```

### Archive for App Store
1. Open project in Xcode
2. Select "Any iOS Device" as destination
3. Product > Archive
4. Follow App Store Connect guidelines

## Code Signing

For development:
- Code Signing Style: Automatic
- Team: Set in Xcode project settings

For distribution:
- Update `DEVELOPMENT_TEAM` in project.pbxproj
- Configure provisioning profiles
- Update bundle identifier if needed

## Testing

### SwiftUI Previews

All views include preview providers:
```swift
#Preview {
    ContentView()
}
```

Use Xcode's Canvas (⌥⌘↵) to see live previews.

### Device Testing

1. Connect iPhone/iPad via USB
2. Trust computer on device
3. Select device in Xcode
4. Run (⌘R)

### Simulator Testing

Supports all iOS 16+ simulators:
- iPhone SE (3rd gen)
- iPhone 14/15 series
- iPad Pro (all sizes)
- iPad Air

## Performance Considerations

- Network requests use URLSession with async/await patterns
- UI updates are dispatched to main thread via `DispatchQueue.main.async`
- Movement commands are designed for high-frequency sending
- API includes completion handlers for async feedback

## Accessibility

The app uses standard SwiftUI components which support:
- VoiceOver
- Dynamic Type
- Increased Contrast
- Reduce Motion

## Future Enhancements

Potential improvements:
- [ ] Add haptic feedback for buttons
- [ ] Implement video streaming view
- [ ] Add command history/logging
- [ ] Support for multiple Spot robots
- [ ] Offline mode with command queuing
- [ ] Landscape-optimized layout for iPhone
- [ ] iPad split-view support
- [ ] Widget for quick controls
- [ ] watchOS companion app

## Version History

- **v1.0** (2026-02-08) - Initial release
  - Connection management
  - Power and stance controls
  - Movement controls
  - Gait selection
  - Animation controls
  - Emergency stop functionality

## License

Created for Spot robot control purposes.
See LICENSE file for details.

## Support

For issues or questions:
1. Check QUICKSTART.md for common solutions
2. Review API_SPEC.md for backend requirements
3. Check Xcode console for error messages
4. Verify backend is running and accessible

## Credits

Built with:
- SwiftUI
- URLSession
- SF Symbols
- Xcode 15

Designed for Boston Dynamics Spot via FastAPI backend.
