# Marvel Heroes App


This is a SwiftUI-based Marvel character browser built as a showcase project. The app lets users browse Marvel heroes, view details, and build a personal squad. I focused on clean architecture, modern iOS best practices, and robust UI testing.

## Tech Stack

- **SwiftUI** for all UI and navigation
- **Combine** for reactive state management
- **Swinject** for dependency injection
- **Alamofire** for networking
- **UserDefaults** for persisting the squad
- **Async/Await** for modern concurrency

## API Configuration

- All API keys, base URLs, and secrets are managed in a dedicated configuration file. This keeps sensitive information out of the codebase and makes it easy to switch between environments or update credentials without code changes.
- The API manager reads from this config for all network requests.

## Mock Data Usage

- The app uses mock data not only for UI testing, but also in normal usage. This is because the Marvel API is frequently unavailable or unreliable.
- Whenever the API is down or unreachable, the app automatically falls back to local mock JSON data, so users can still browse and interact with the app.
- During UI tests, mock data is always injected to guarantee predictable and repeatable results.

## Architecture & Methods

- **MVVM**: The project uses a clear Model-View-ViewModel structure.
- **Dependency Injection**: All view models and services are resolved through Swinject, making the app modular and test-friendly.
- **Launch Arguments**: UI tests use launch arguments to inject mock data or reset UserDefaults, so tests are always predictable.
- **Accessibility**: Key UI elements have accessibility identifiers for reliable UI testing.

## Testing

- UI tests cover the main user flows:
    - Verifying the home screen loads
    - Navigating to character pages
    - Adding a hero to the squad and confirming they appear
- Mock data is loaded automatically during UI tests, so tests don’t depend on the network.

## Notes

- Squad state is saved in UserDefaults, so it persists between launches unless reset by a test.
- The app uses infinite scrolling for the character list and falls back to local mock data if the API fails.
- All code is written with readability and maintainability in mind.
