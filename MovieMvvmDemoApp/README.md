# 🎬 Lord of the Rings Movies

A sample iOS application that displays a list of *Lord of the Rings* movies and their characters, built from scratch using **Swift** and **SwiftUI**.

This project demonstrates the use of **MVVM architecture**, **Combine**, and **modular API services** for a clean, maintainable codebase.

---

## 📋 Features

- ✅ Movie List View  
- ✅ Character List View  
- ✅ Character Detail View  
- ✅ Quotes View (conditionally shown)

---

## ⚙️ Prerequisites

To run this project, ensure you have:

- macOS **14.0.7** or later  
- **Xcode 15.3** or later  
- Swift **5.9** or later (bundled with Xcode 15.3)

---
## 📱 Screens & Description

🎥 Movie List View

Displays a list of Lord of the Rings movies.

Implemented using List with a custom cell.

Each cell shows:

The movie title

A navigation arrow to view its characters

🧝‍♂️ Character List View

Shows characters from the selected movie.

Also uses a List with custom cells.

Each cell shows:

The character's name

A navigation arrow to view character details

📖 Character Detail View

Shows details of a selected character, including:

Name

Date of Birth

Spouse

Race

Gender

Wiki link

🗣️ Quotes View (Optional)

Shows a list of quotes associated with the selected movie.

Controlled by a flag ShowQuote in Info.plist.

Appears conditionally in the Character List View.

🧪 Testing

Includes unit tests using XCTest

API calls are abstracted using a MockAPIService for testing view models in isolation

🛠️ Technologies Used

Swift 5

SwiftUI

Combine

MVVM Architecture

XCTest for unit testing


