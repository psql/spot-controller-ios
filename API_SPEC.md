# Spot Controller API Specification

This document describes the REST API endpoints that the FastAPI backend must implement for the iOS app to function properly.

## Base URL

```
http://localhost:8081
```

## Endpoints

### Connection Management

#### Connect to Spot
```
POST /api/connect
```
**Response:** 200 OK
```json
{
  "status": "connected",
  "message": "Successfully connected to Spot"
}
```

#### Disconnect from Spot
```
POST /api/disconnect
```
**Response:** 200 OK
```json
{
  "status": "disconnected",
  "message": "Successfully disconnected from Spot"
}
```

### Power Management

#### Power On
```
POST /api/power/on
```
**Response:** 200 OK

#### Power Off
```
POST /api/power/off
```
**Response:** 200 OK

### Stance Control

#### Stand
```
POST /api/stand
```
**Response:** 200 OK

#### Sit
```
POST /api/sit
```
**Response:** 200 OK

### Emergency Stop

#### Trigger E-Stop
```
POST /api/estop
```
**Response:** 200 OK

#### Release E-Stop
```
POST /api/estop/release
```
**Response:** 200 OK

### Movement Control

#### Move
```
POST /api/move/{direction}
```
**Path Parameters:**
- `direction`: forward | backward | left | right | stop

**Response:** 200 OK

### Gait Selection

#### Set Gait
```
POST /api/gait
Content-Type: application/json
```
**Request Body:**
```json
{
  "gait": "walk"
}
```
**Gait Options:**
- auto
- walk
- trot
- crawl
- amble

**Response:** 200 OK

### Animation Control

#### Play Animation
```
POST /api/animation/{animation_name}
```
**Path Parameters:**
- `animation_name`: wave | dance | bow | spin | sit_pretty | stretch

**Response:** 200 OK

### Pose Control

#### Set Custom Pose
```
POST /api/pose
Content-Type: application/json
```
**Request Body:**
```json
{
  "yaw": 0.0,
  "roll": 0.0,
  "pitch": 0.0
}
```
**Parameter Ranges:**
- `yaw`: -0.8 to 0.8 (radians)
- `roll`: -0.5 to 0.5 (radians)
- `pitch`: -0.5 to 0.5 (radians)

**Response:** 200 OK

## Error Responses

All endpoints should return appropriate HTTP status codes:
- `200 OK` - Success
- `400 Bad Request` - Invalid parameters
- `500 Internal Server Error` - Server or robot error

**Error Response Format:**
```json
{
  "status": "error",
  "message": "Description of what went wrong"
}
```

## Notes

1. All POST requests should accept `application/json` content type
2. All responses should be JSON formatted
3. The backend should maintain state (connection status, power status, etc.)
4. Commands that require Spot to be powered on should check power state
5. Movement commands should only work when Spot is standing
6. Animations should only work when Spot is standing
7. The backend should handle Boston Dynamics SDK communication
8. Consider implementing request timeouts (suggested: 5 seconds)
9. Consider implementing command queuing for sequential operations
10. The backend should handle SDK errors gracefully and return appropriate error messages

## Implementation Example (FastAPI)

```python
from fastapi import FastAPI, HTTPException
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
    # Implement Spot SDK connection logic
    return {"status": "connected", "message": "Successfully connected to Spot"}

@app.post("/api/power/on")
async def power_on():
    # Implement power on logic
    return {"status": "success"}

@app.post("/api/stand")
async def stand():
    # Implement stand command
    return {"status": "success"}

@app.post("/api/move/{direction}")
async def move(direction: str):
    # Implement movement logic
    return {"status": "success"}

@app.post("/api/gait")
async def set_gait(request: GaitRequest):
    # Implement gait selection logic
    return {"status": "success"}

@app.post("/api/pose")
async def set_pose(request: PoseRequest):
    # Implement pose control logic
    return {"status": "success"}
```

## Testing

You can test the API endpoints using curl:

```bash
# Connect
curl -X POST http://localhost:8081/api/connect

# Power on
curl -X POST http://localhost:8081/api/power/on

# Stand
curl -X POST http://localhost:8081/api/stand

# Move forward
curl -X POST http://localhost:8081/api/move/forward

# Set gait
curl -X POST http://localhost:8081/api/gait \
  -H "Content-Type: application/json" \
  -d '{"gait": "walk"}'

# Set pose
curl -X POST http://localhost:8081/api/pose \
  -H "Content-Type: application/json" \
  -d '{"yaw": 0.0, "roll": 0.0, "pitch": 0.0}'
```
