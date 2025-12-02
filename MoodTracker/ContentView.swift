//
//  ContentView.swift
//  MoodTracker
//
//  Created by Керемет  on 12/2/25.
//
import SwiftUI

//In this file I made a small Mood Tracker app using SwiftUI.
//The program allows the user to select their mood, write a brief note, save it, and then view a history of all the moods they have saved.

enum Mood: String, CaseIterable, Identifiable, Codable {
    case angry = "😡"
    case sad = "🙁"
    case neutral = "😐"
    case happy = "🙂"
    case great = "😄"
    
    // each mood must have a unique id and we have to identify it
    var id: String {
        rawValue
        
    }
    
    var label: String {
        switch self {
        case .angry:   return "Very angry"
        case .sad:       return "Sad"
        case .neutral:   return "Okay"
        case .happy:     return "Happy"
        case .great:     return "Great"
        }
    }
}

// Saving the mood in the history
// the mood, note, date, and a unique ID.

struct MoodEntry: Identifiable, Codable {
    
    let id: UUID
    let date: Date
    let mood: Mood
    let note: String
    
//  gives the entry a new id and current date.
    
    init(id: UUID = UUID(), date: Date = Date(), mood: Mood, note: String) {
        self.id = id
        self.date = date
        self.mood = mood
        self.note = note
    }
}


struct ContentView: View {
    
// here I am saving the data in a UserDefaults(main storage)
    @AppStorage("moodEntries") private var moodEntriesData: Data = Data()
    @State private var entries: [MoodEntry] = []
    
    // Current emothion selected
    @State private var selectedMood: Mood = .happy
    @State private var note: String = ""
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                // Current emothion picker
                moodPickerSection
                
                // Write the note
                noteSection
                
                // Here I installed the button to save the emotion and the note
                Button(action: addEntry) {
                    Text("Save Mood")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.accentColor)
                        .foregroundStyle(.white)
                        .cornerRadius(12)
                }
                .padding(.horizontal)
                
                Divider()
                
                // History
                // List of previous entries (sorted newest first)
                List(entries.sorted(by: { $0.date > $1.date })) { entry in
                    HStack(alignment: .top, spacing: 12) {
                        Text(entry.mood.rawValue)
                            .font(.largeTitle)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(entry.mood.label)
                                .font(.headline)
                            
                            Text(formattedDate(entry.date))
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            
                            if !entry.note.isEmpty {
                                Text(entry.note)
                                    .font(.body)
                            }
                        }
                    }
                    .padding(.vertical, 4)
                }
            }
            .navigationTitle("Mood Tracker")
        }
        // Shows saved entries
        .onAppear(perform: loadEntries)
    }
    
    
    // Here the user picking the mood
    
    private var moodPickerSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("How do you feel today?")
                .font(.headline)
                .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                // Spacing between the emoji icons
                HStack(spacing: 12) {
                    ForEach(Mood.allCases) {
                        mood in
                            Button {
                            selectedMood = mood
                        }
                     
                label:
                        
                        {
                            VStack {
                                Text(mood.rawValue)
                                    .font(.largeTitle)
                                Text(mood.label)
                                    .font(.caption)
                            }
                            .padding(10)
                            .frame(width: 80)
                            .background(selectedMood == mood ? Color.accentColor.opacity(0.2) : Color(.systemGray6))
                            .cornerRadius(12)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal)
            }
        }
    }
    
    // Writing the note section
    
    private var noteSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Add a note (optional)")
                .font(.headline)
                .padding(.horizontal)
            
            TextField("What happened today?", text: $note, axis: .vertical)
                .textFieldStyle(.roundedBorder)
                .padding(.horizontal)
        }
    }
    
    // Action:
    // Called when the user using the button "Save Mood"
    
    private func addEntry() {
        // Building a new attachment using selected mood and note
        let newEntry = MoodEntry(mood: selectedMood, note: note.trimmingCharacters(in: .whitespacesAndNewlines))
        //the new note is added
        entries.append(newEntry)
        // the text area cleared for the new note
        note = ""
        saveEntries()
    }
    
    // Saving and loading
    
    private func loadEntries() {
        guard !moodEntriesData.isEmpty else { return }
        
        let decoder = JSONDecoder()
        if let decoded = try? decoder.decode([MoodEntry].self, from: moodEntriesData) {
            entries = decoded
        }
    }
    
    private func saveEntries() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(entries) {
            moodEntriesData = encoded
        }
    }
    
// Turning the built in date function to readable date 
    
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
