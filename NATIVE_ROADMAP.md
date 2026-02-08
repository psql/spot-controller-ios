# Native Swift Implementation Roadmap (Option A)

This document outlines the plan for creating a **truly self-contained iOS app** that requires no Python backend.

## Current Status: Foundation Ready

✅ Xcode project structure created
✅ gRPC-Swift dependency added
✅ SpotClient.swift skeleton created
✅ iOS app UI completed (connects to backend for now)

## What Needs To Be Built

### Phase 1: Protocol Buffers Setup (1-2 days)

**Tasks:**
1. Install protoc compiler and Swift plugin
2. Download all Spot .proto files from Boston Dynamics
3. Generate Swift code from ~50 protobuf files
4. Integrate generated code into Xcode project
5. Resolve any compilation issues

**Deliverable**: Swift classes for all Spot messages

### Phase 2: Core Services (3-4 days)

**Implement gRPC service clients:**

1. **Auth Service** (Day 1)
   - GetAuthToken RPC
   - Token refresh logic
   - JWT handling
   - Credential storage

2. **Directory Service** (Day 1)
   - List services
   - Service discovery
   - Authority handling

3. **Time Sync Service** (Day 1-2)
   - Clock synchronization
   - Offset calculation
   - Continuous sync maintenance

4. **Lease Service** (Day 2)
   - Acquire lease
   - Lease keepalive thread
   - Return lease
   - Lease wallet management

5. **E-Stop Service** (Day 2-3)
   - E-Stop endpoint creation
   - Keepalive maintenance
   - Trigger/release
   - Status monitoring

6. **Robot Command Service** (Day 3-4)
   - Stand command
   - Sit command
   - Velocity commands
   - Body pose commands
   - Command feedback

7. **Robot State Service** (Day 4)
   - Query robot state
   - Battery status
   - Power state
   - Kinematic state

### Phase 3: Safety & Business Logic (2-3 days)

**Implement safety features:**

1. **Watchdog Thread**
   - Monitor velocity timeout
   - Auto-stop on timeout
   - Thread-safe implementation

2. **Connection Management**
   - Auto-reconnect
   - Connection health monitoring
   - Graceful shutdown

3. **Error Handling**
   - gRPC error mapping
   - User-friendly error messages
   - Retry logic

4. **Keepalive Management**
   - Lease keepalive background task
   - E-Stop keepalive background task
   - iOS background mode handling

### Phase 4: SwiftUI Integration (2-3 days)

**Connect Swift client to existing UI:**

1. Replace HTTP API calls with SpotClient calls
2. Add state management (@ObservableObject)
3. Real-time status updates
4. Error handling in UI
5. Loading states and progress indicators

### Phase 5: Advanced Features (3-4 days)

**Port advanced features from web version:**

1. **Custom Gaits**
   - Mobility parameters
   - Body height control
   - Locomotion hints

2. **Animations**
   - Body pose animations
   - Oscillator-based animations
   - Swagger walk
   - Tail wag

3. **Real-time Telemetry**
   - Continuous state polling
   - Battery monitoring
   - Status displays

### Phase 6: Testing & Polish (2-3 days)

1. Comprehensive testing on iPhone
2. Connection reliability testing
3. Error scenario handling
4. UI/UX refinement
5. Performance optimization
6. Memory leak checks
7. Background mode testing

## Total Timeline

**Estimated: 15-20 days of focused work**

Breaking it down:
- **Week 1**: Protobuf setup + Core services (Auth, Lease, E-Stop)
- **Week 2**: Commands, State, Safety logic
- **Week 3**: UI integration, Advanced features, Testing

## Technical Challenges

### Challenge 1: Protobuf Code Generation
**Solution**: Use protoc with swift plugin, may need manual fixes

### Challenge 2: gRPC Certificate Validation
**Issue**: Spot uses self-signed certs
**Solution**: Disable cert verification (already in SpotClient.swift)

### Challenge 3: Background Keepalives
**Issue**: iOS suspends background tasks aggressively
**Solution**: Use iOS Background Tasks API for keepalives

### Challenge 4: Time Synchronization
**Issue**: Critical for Spot commands
**Solution**: Implement NTP-style sync with offset tracking

### Challenge 5: Threading & Concurrency
**Issue**: Keepalives need background threads
**Solution**: Use Swift async/await + Task groups

## Benefits of Native Implementation

Once complete:
- ✅ No Python dependency
- ✅ No external backend needed
- ✅ True standalone iPhone app
- ✅ Faster (no network roundtrip to backend)
- ✅ Works anywhere (just iPhone + Spot WiFi)
- ✅ App Store ready (could distribute)
- ✅ Professional solution
- ✅ Better battery life (no Mac running)

## Development Approach

**Incremental development:**
1. Build one service at a time
2. Test each service before moving on
3. Keep backend version working as fallback
4. Gradually replace HTTP calls with gRPC calls
5. User can test at each milestone

## Milestones

- [ ] **Milestone 1**: Protobuf codegen complete
- [ ] **Milestone 2**: Can authenticate with Spot
- [ ] **Milestone 3**: Can acquire lease
- [ ] **Milestone 4**: Can send stand/sit commands
- [ ] **Milestone 5**: Can send velocity commands
- [ ] **Milestone 6**: Can query robot state
- [ ] **Milestone 7**: All safety features working
- [ ] **Milestone 8**: Feature parity with web version
- [ ] **Milestone 9**: Advanced features (animations, gaits)
- [ ] **Milestone 10**: Production ready, tested, polished

## Next Steps for Option A

After you have Option B working:

1. I'll start Phase 1 (protobuf setup)
2. Generate Swift code from Spot's protobufs
3. Implement Auth service first
4. You can test authentication
5. Continue through phases incrementally

**Each phase will be committed to GitHub so you can test progress!**

## Resources Needed

- Boston Dynamics Spot SDK protobufs
- Swift gRPC library (already added)
- Apple Developer account (for iOS deployment)
- Test Spot for validation
- Time and patience! 😄

---

**For now: Let's get Option B working so you can use Spot TODAY!**

**Then we'll build Option A properly over the next few weeks.**
