# Project Update Summary - February 28, 2026

## 1. API Configuration
- **Base URL Update**: Changed the `ApiClient` default base URL to `http://192.168.1.51:7156/api` to point to the new local server.
- **ApiClient Enhancements**: Added support for `PUT`, `PATCH`, and `DELETE` HTTP methods. Included basic console logging for requests and responses to aid debugging.

## 2. Authentication (Auth)
- **Endpoint Alignment**: Updated `AuthApi` to match Swagger documentation.
  - Login: `/auth/login`
  - Register: `/auth/register` (updated from `/users`).
- **DTO Alignment**: Adjusted registration payload to use only `email` and `password` as per `RegisterDto`.

## 3. Data Models & Repositories
- **New Models**: Created `HomeModel`, `RoomModel`, and `DeviceModel` in `lib/features/home/data/models/home_models.dart` based on Swagger schemas.
- **HomeRepository**: Added a new repository to handle home and room operations (`/api/Home` and `/api/Room`).
- **DeviceRepository**: 
  - Updated to return `DeviceModel` instead of raw strings.
  - Added `toggleDeviceStatus` using the `PATCH /api/devices/{id}/status` endpoint.
  - Added `getDevicesByRoom` using the `/api/devices/by-room/{roomId}` endpoint.

## 4. Feature Integration: Location & Rooms
- **RoomService Update**:
  - Implemented `getDevicesByRoom` to fetch live data from the API.
  - Mapped room names to integer IDs (e.g., "Living Room" or "phòng kh" maps to `roomId: 2`).
  - Removed mock data fallback for more transparent testing.
- **MobileLocationPage Refactor**:
  - Converted to `ConsumerStatefulWidget` to use Riverpod providers.
  - Implemented asynchronous data fetching on initialization and room switching.
  - Added a `CircularProgressIndicator` to show loading states while calling the API.

## 5. Bug Fixes & Stability
- **Import Fixes**: Resolved invalid relative paths in `device_state.dart`.
- **Logic Cleanup**: Removed references to undefined `roomDevices` maps in the location page, switching entirely to the `devices` list managed via the API service.
- **Environment**: Successfully prepared and launched the app using `flutter run -d chrome --web-port=51799`.

## 6. Current API State (Testing)
- Testing confirmed that `roomId: 2` (Living Room) correctly fetches the single device present on the server as per user feedback.
