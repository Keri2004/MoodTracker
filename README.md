# Mood Tracker App

A simple SwiftUI application that allows users to record their daily mood and write notes.  
All entries are stored using `AppStorage` and decoded using `Codable`.


- Select mood from preset emoji options
- Add a note for each day
- Save entries persistently 
- View mood history in a scrollable list

- Swift
- SwiftUI
- AppStorage
- Enum for Mood Types


- `Mood`: Enum representing mood choices with emoji raw values
- `MoodEntry`: Struct storing each mood entry (id, date, mood, note)
- `MoodView`: UI to pick mood and add notes
- `HistoryView`: Displays previous entries

  


Run the project:
1. Clone the repository  
2. Open the `.xcodeproj` or `.xcworkspace` file  
3. Run on Simulator or device  

