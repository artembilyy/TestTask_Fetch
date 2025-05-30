# Fetch Recipe App

A SwiftUI recipe browsing app with hybrid architecture and SPM modularization.

## Summary

The app displays recipes from the provided API in a clean, modern interface with easy scalability:

**Key Features:**
- 📱 Modern SwiftUI interface with alphabetical grouping
- 🔍 Real-time search by recipe name or cuisine type
- 🖼️ Custom disk-based image caching system
- 🔄 Pull-to-refresh functionality
- ⚡ Optimized network usage with async/await

**Architecture Highlights:**
- Hybrid architecture: Clean Architecture + MVVM pattern
- ViewModel acts as a Binder between View and Domain layer
- Core business logic encapsulated in Use Cases (Domain layer)
- Protocol-based dependency injection for testability

## Focus Areas

I prioritized these key areas based on requirements and production-ready code standards:

**1. Architecture & Code Organization (I love experimenting with different development approaches the most)**
- Implemented Clean Architecture + MVVM hybrid to demonstrate separation of concerns
- Used protocols and dependency injection for testability
- Separated domain logic from UI - ViewModel only binds View with Domain

**2. Network & Image Handling**
- Built custom image caching system using SHA256 hashing
- Implemented proper async/await patterns throughout

**3. Testing & Quality**
- Used mock repositories to test use cases in isolation
- Covered core business logic with unit tests

**4. User Experience**
- Modern SwiftUI interface with smooth animations
- Proper loading states and error handling, empty states

## Time Spent

My day turned out quite busy due to current full-time work, which added difficulty in concentration, but I was determined to start and finish today, so I tried to divide the work into categories.

**Total Time: ~9 hours** allocated as follows:
- **Architecture Setup (1.5 hours)**: Defining layers, protocols, and project structure
- **Core Implementation (3 hours)**: API integration, models, and business logic
- **Image Caching System (0.5 hours)**: Custom disk cache implementation
- **UI Development (2 hours)**: SwiftUI views, navigation, and styling
- **Testing (1 hour)**: Unit tests for use cases and domain logic
- **Polish & Refinement (0.5 hours)**: Error handling, state testing
- **Writing this README (0.5 hours)**

## Trade-offs and Decisions

**Hybrid Architecture vs Simplicity**
- **Decision**: Chose Clean Architecture + MVVM over simple MVVM
- **Trade-off**: More files and complexity than needed for such a simple app, but done intentionally
- **Reasoning**: Demonstrates understanding of scalable architectural patterns, active learning of different approaches

**Comprehensive Error Handling vs Minimal Implementation**
- **Decision**: Created detailed error types with user-friendly messages
- **Trade-off**: More code complexity for edge cases that rarely occur
- **Reasoning**: Shows production-ready thinking about error scenarios

**Protocol-Heavy Design vs Direct Implementation**
- **Decision**: Used protocols for all repository and use case layers
- **Trade-off**: More abstraction than necessary for current scope
- **Reasoning**: Enables better testing and future extensibility

## Weakest Part of the Project

**Over-engineered Architecture for Scope**

The hybrid architecture implementation (Clean Architecture + MVVM), while demonstrating good practices, is somewhat over-engineered for two screens. Specifically:

- **Too many layers**: Simple MVVM + Repository would suffice for a basic app
- **Excessive abstraction**: ViewModel as Binder + Use Cases create additional complexity
- **Unused capabilities**: Some protocols and error types are created "for growth"

**Alternative approach**: Simple MVVM with Repository pattern would probably! be more suitable for this scope.

## Additional Information

**Technical Decisions:**
- **Swift 6.0**: Used latest language features including strict concurrency
- **iOS 16+**: Leveraged modern SwiftUI capabilities
- **No third-party dependencies**: Built everything using Apple frameworks only
- **File organization**: Separated into logical Swift packages for modularity
- **Code formatting**: All code formatted with SwiftFormat for consistency

**Implementation Features:**
- Secret message view adds a personal touch, demonstrating custom animations 😊
- Caching system handles edge cases (cache corruption, insufficient space)
- Search includes debouncing to avoid excessive filtering
- Proper handling of loading states, errors, and empty data

**Process Insights:**
- Swift 6 strict concurrency took longer than expected
- Balancing between demonstrating skills and solution practicality
- Creating production-ready code within tight timeframes after work day
