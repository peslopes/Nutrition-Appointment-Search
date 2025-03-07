# Nutrition Appointment Search

## Overview

The application displays a list of nutritionists and allows users to view detailed profiles of each professional.

## Features

- List of professionals with profile picture, name, rating, languages, and areas of expertise.
- Sorting options by Best Match, Rating, and Popularity.
- Detailed profile view with an expandable "About Me" section.
- Navigation between screens implemented with SwiftUI.
- Two-layer caching system:
  - Short-term cache: Stored in volatile memory using NSCache.
  - Persistent cache: Stored using SwiftData for offline access.
- Offline support, displaying previously fetched data.
- Pagination for better management of the professionals list.

## API Integration

This application fetches nutrition professionals' data from the NutriSearch API: [NutriSearch API](https://nutrisearch.vercel.app).

## Endpoints Used:

Get professionals list
  ```bash
  GET /professionals/search?limit=4&offset=0&sort_by=best_match
  ```

Parameters:

- limit: Number of professionals per request (default: 4)
- offset: Pagination offset (default: 0)
- sort_by: Sorting criteria (best_match, rating, most_popular)

Used to fetch and display a list of professionals.

Get professional details
  ```bash
  GET /professionals/:id
  ```

Retrieves details for a specific professional, including profile picture, rating, languages, expertise, and "About Me" section.

## Technologies Used

- Language: Swift
- Frameworks: SwiftUI
- Architecture: MVVM (Model-View-ViewModel)
- State Management: Combine
- Networking: URLSession
- Cache: CacheHandler using NSCache (volatile memory) and SwiftData (persistent storage)
- Testing: XCTest for unit tests

## Installation & Usage

1. Clone the repository:
  ```bash
  git clone https://github.com/peslopes/Nutrition-Appointment-Search.git
  ```

2. Navigate to the project directory:
  ```bash
  cd Nutrition-Appointment-Search
  ```

3. Open the project in Xcode.

4. Run the application on a simulator or device.

## Architecture

This project follows the **MVVM (Model-View-ViewModel)** architecture:

- **Model**:
  - Represents the data structures.
- **View**:
  - User interface components built with **SwiftUI**.
- **ViewModel**:
  - Manages the state and logic, communicating between the Model and the View.

## Tests

### Unit Tests
- Written with `XCTest` for core ViewModels.
- Mock objects are used to simulate API responses and improve test reliability.

Run all tests:
  ```bash
  Cmd + U
  ```
