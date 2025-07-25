# MatchMateSwiftDataApp

MatchMateSwiftDataApp is a SwiftUI-based iOS application showcasing profile matching functionality with remote data fetching, local persistence using SwiftData, and offline support. The app fetches random user profiles from a public API, displays them in a scrollable and filterable list, and allows users to accept or decline profiles.

It uses modern Swift concurrency, SwiftData for persistence, and third-party libraries such as Alamofire and SDWebImageSwiftUI for networking and async image loading, respectively.

---

## Features

- Fetches random user profiles asynchronously from [randomuser.me](https://randomuser.me) API.
- Utilizes **SwiftData** for local persistence and offline caching of profiles.
- Supports offline mode with cached profile browsing and filtering by status: **All**, **Accepted**, **Declined**.
- User profiles include images loaded asynchronously with **SDWebImageSwiftUI**.
- Clean and reactive UI using SwiftUI views:
  - `HomeScreen`: Entry point with navigation and filter toolbar.
  - `ProfileListView` and `ProfileCardView`: Display user profiles with action buttons.
  - `EmptyStateView`: Shows user-friendly messages when no profiles are available per filter.
  - `ToastView`: Displays offline connection notifications.
- Uses **async/await** and structured concurrency to handle network requests.
- Networking via **Alamofire** with robust error handling.
- Data filtering, sorting, and synchronization support with SwiftData models.

---

## Key Source Files and Architecture

### Data Models

- **UserProfile.swift**

  Defines the `UserProfile` model annotated with `@Model` for SwiftData persistence.  
  Properties include:
  - Unique `id`
  - User details: `name`, `age`, `gender`, `email`, `phone`, `nationality`
  - Location information and profile image URLs
  - `status` property of enum type `ProfileStatus` (`new`, `accepted`, `declined`)
  - Optionally cached profile picture data (`Data`)
  - Timestamps and synchronization flags for data management

- **UserResponse.swift**

  Defines `UserResponse` struct conforming to `Codable`, representing API responses from randomuser.me.  
  Supports decoding nested user details like name, location, login ID, birth info, pictures, and nationality.  
  Designed to map raw API JSON into app models.

### MVVM Pattern

- **ViewModel (MatchMateViewModel)** manages:
  - Fetching remote profiles via `ApiService`
  - Mapping and inserting `UserResponse.User` objects into persisted `UserProfile` entities
  - Status updates and filtering logic on profiles
  - Coordination with SwiftData's `ModelContext`

- **Views** listen to the ViewModel using `@Published` properties and update UI reactively.

### Networking

- **ApiService**

  Uses Alamofire integrated with Swift's async/await model to fetch and decode user profiles from the REST API.

### Persistence

- SwiftData's `ModelContext` helps manage local storage
- Supports queries with `FetchDescriptor` and filtering predicates for efficient data retrieval

---

## Installation

1. Clone or download the repository.
2. Open the `.xcodeproj` or `.xcworkspace` file in Xcode 15.0 or newer.
3. Ensure Swift Package Manager automatically resolves dependencies:
   - Alamofire
   - SDWebImageSwiftUI
4. Build and run on iOS 16.0 or newer simulators or devices.

---

## Usage

- Launch the app to fetch profiles from the API.
- Use the toolbar filter menu to display **All**, **Accepted**, or **Declined** profiles.
- Accept or decline profiles using buttons on each profile card.
- Refresh profiles manually via the toolbar refresh button.
- When offline, cached profiles are shown with an offline toast notification.
- View empty state messages when no profiles are available for the selected filter.

---

## Requirements

- iOS 16.0+
- Xcode 15.0+
- Swift 5.8+
- SwiftData framework (Apple's persistence framework)
- Internet connection for initial profile fetching (offline caching is supported)

---

## Dependencies

- [Alamofire](https://github.com/Alamofire/Alamofire) — For networking and API requests.
- [SDWebImageSwiftUI](https://github.com/SDWebImage/SDWebImageSwiftUI) — Asynchronous image loading and caching.

---

## License

MIT License — Feel free to use, modify, and distribute this project.

---

Thank you for checking out **MatchMateSwiftDataApp**!  
Developed by Him Bhatt, July 2025.
