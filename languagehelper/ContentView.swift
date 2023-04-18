import SwiftUI
import Speech

struct ContentView: View {
    @State private var isRecording = false
    @State private var recognizedText = ""
    @State private var selectedSubject = ""
    @State private var feedback = ""
    @State private var useSpeech = false
    
    private let availableSubjects = ["Greetings", "Work", "Travel", "Food"]
    
    var body: some View {
        VStack {
            Text("How well do you speak English?")
                .font(.headline)
                .padding()
            if useSpeech {
                ZStack {
                    Color(.secondarySystemBackground)
                        .cornerRadius(10)
                    Text(recognizedText)
                        .padding()
                }
                .frame(height: 100)
                .padding()
            } else {
                TextEditor(text: $recognizedText)
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(10)
                    .padding()
                    .disabled(isRecording)
            }
            HStack {
                Button(action: {
                    if useSpeech {
                        startRecording()
                    }
                }) {
                    Image(systemName: "mic.fill")
                        .font(.system(size: 32))
                        .foregroundColor(.blue)
                }
                .disabled(isRecording || !useSpeech)
                Button(action: {
                    if useSpeech {
                        stopRecording()
                    }
                }) {
                    Image(systemName: "stop.fill")
                        .font(.system(size: 32))
                        .foregroundColor(.red)
                }
                .disabled(!isRecording || !useSpeech)
                Button(action: {
                    useSpeech = !useSpeech
                }) {
                    Image(systemName: useSpeech ? "keyboard" : "mic")
                        .font(.system(size: 32))
                        .foregroundColor(.blue)
                }
                .padding(.leading)
            }
            .padding()
            Picker("Select a subject", selection: $selectedSubject) {
                ForEach(availableSubjects, id: \.self) { subject in
                    Text(subject)
                }
            }
            .pickerStyle(.segmented)
            .padding()
            Button(action: analyzeSpeech) {
                Text("Analyze")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding()
            Text(feedback)
                .font(.headline)
                .padding()
        }
    }
    
    private func startRecording() {
        isRecording = true
    }
    
    private func stopRecording() {
        isRecording = false
        // Use SFSpeechRecognizer to convert speech to text
    }
    
    private func analyzeSpeech() {
        // Use the recognized text and selected subject to call the AI component
        // The AI component will provide feedback on the user's English speaking proficiency
        let text = recognizedText.lowercased()
        var feedback = ""
        switch selectedSubject {
        case "Greetings":
            if text.contains("hello") {
                feedback = "Great job with your greeting!"
            } else {
                feedback = "Try starting with 'hello' or 'hi' next time."
            }
        case "Work":
            if text.contains("presentation") {
                feedback = "Your enunciation and pacing were good, but try to vary your tone more next time."
            } else {
                feedback = "Make sure to speak clearly and confidently in a work setting."
            }
        case "Travel":
            if text.contains("directions") {
                feedback = "Excellent job asking for directions!"
            } else {
                feedback = "Make sure to ask for help if you're lost while traveling."
            }
        case "Food":
            if text.contains("restaurant") {
                feedback = "You did a great job ordering at the restaurant!"
            } else {
                feedback = "Next time you order food, try to use more descriptive language to make your preferences clear."
            }
        default:
            feedback = "Please select a subject to analyze."
        }
        self.feedback = feedback
    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
