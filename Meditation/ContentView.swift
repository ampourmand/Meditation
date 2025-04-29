import SwiftUI
import UserNotifications
import AVFoundation

// MARK: - Data Model
struct MeditationQuote: Identifiable {
    let id = UUID()
    let text: String
    let author: String
}

class QuoteManager: ObservableObject {
    @Published var currentQuote: MeditationQuote

    let quotes = [
        MeditationQuote(text: "Breathing in, I calm my body. Breathing out, I smile.", author: "Thich Nhat Hanh"),
        MeditationQuote(text: "The present moment is the only time over which we have dominion.", author: "Thich Nhat Hanh"),
        MeditationQuote(text: "Peace comes from within. Do not seek it without.", author: "Buddha"),
        MeditationQuote(text: "The mind is everything. What you think you become.", author: "Buddha"),
        MeditationQuote(text: "You are the sky. Everything else is just the weather.", author: "Pema Chödrön"),
        MeditationQuote(text: "Quiet the mind, and the soul will speak.", author: "Ma Jaya Sati Bhagavati"),
        MeditationQuote(text: "The goal of meditation isn't to control your thoughts, it's to stop letting them control you.", author: "Anonymous"),
        MeditationQuote(text: "Your calm mind is the ultimate weapon against your challenges.", author: "Bryant McGill"),
        MeditationQuote(text: "The best way to capture moments is to pay attention.", author: "Jon Kabat-Zinn"),
        MeditationQuote(text: "Meditation is not evasion; it is a serene encounter with reality.", author: "Thich Nhat Hanh"),
        MeditationQuote(text: "Within you, there is a stillness and a sanctuary to which you can retreat at any time.", author: "Hermann Hesse"),
        MeditationQuote(text: "Mindfulness isn't difficult. We just need to remember to do it.", author: "Sharon Salzberg"),
        MeditationQuote(text: "Be where you are, otherwise you will miss your life.", author: "Buddha"),
        MeditationQuote(text: "To understand the immeasurable, the mind must be extraordinarily quiet, still.", author: "Jiddu Krishnamurti"),
        MeditationQuote(text: "The quieter you become, the more you can hear.", author: "Ram Dass")
    ]

    init() {
        currentQuote = quotes.randomElement()!
    }

    func getRandomQuote() -> MeditationQuote {
        quotes.randomElement()!
    }

    func refreshQuote() {
        currentQuote = getRandomQuote()
    }
}

// MARK: - Notification Manager
class NotificationManager {
    static let shared = NotificationManager()
    private let quotes: [MeditationQuote]

    private init() {
        // Using the same quotes as QuoteManager
        self.quotes = QuoteManager().quotes
    }

    func requestAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                print("Notification permission granted")
            } else if let error = error {
                print("Notification permission error: \(error.localizedDescription)")
            }
        }
    }

    func scheduleNotification(time: Date, frequency: NotificationFrequency) {
        // Remove existing notifications
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()

        let quote = quotes.randomElement()!
        let content = UNMutableNotificationContent()
        content.title = "Daily Meditation Quote"
        content.body = "\"\(quote.text)\" — \(quote.author)"
        content.sound = UNNotificationSound.default

        var dateComponents = Calendar.current.dateComponents([.hour, .minute], from: time)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)

        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error)")
            }
        }

        // If daily is selected, we're done
        if frequency == .daily {
            return
        }

        // For multiple times per day, schedule additional notifications
        if frequency == .twiceDaily || frequency == .threeTimesDaily {
            // Add a notification 12 hours later for twice daily
            dateComponents.hour = (dateComponents.hour! + 12) % 24
            let secondTrigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
            let secondRequest = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: secondTrigger)
            UNUserNotificationCenter.current().add(secondRequest, withCompletionHandler: nil)
        }

        if frequency == .threeTimesDaily {
            // Add a notification 8 hours later for three times daily
            dateComponents.hour = (dateComponents.hour! + 8) % 24
            let thirdTrigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
            let thirdRequest = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: thirdTrigger)
            UNUserNotificationCenter.current().add(thirdRequest, withCompletionHandler: nil)
        }
    }
}

enum NotificationFrequency: String, CaseIterable, Identifiable {
    case daily = "Once a day"
    case twiceDaily = "Twice a day"
    case threeTimesDaily = "Three times a day"

    var id: String { self.rawValue }
}

// MARK: - Main Views
struct ContentView: View {
    @State private var isLoggedIn = false
    @State private var username = ""
    @State private var password = ""
    @StateObject private var quoteManager = QuoteManager()

    var body: some View {
        NavigationView {
            if isLoggedIn {
                HomeView()
                    .environmentObject(quoteManager)
            } else {
                VStack(spacing: 20) {
                    Text("Meditation App")
                        .font(.largeTitle)
                        .bold()

                    TextField("Username", text: $username)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)

                    SecureField("Password", text: $password)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)

                    Button("Login") {
                        isLoggedIn = true
                        // Request notification permission when user logs in
                        NotificationManager.shared.requestAuthorization()
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding(.horizontal)
                }
            }
        }
    }
}

struct HomeView: View {
    @EnvironmentObject var quoteManager: QuoteManager

    var body: some View {
        VStack(spacing: 20) {
            Text("Welcome Back!")
                .font(.title)

            // Daily Quote Card
            DailyQuoteView()
                .padding(.bottom, 20)

            NavigationLink(destination: SessionPlayerView()) {
                Text("Start Meditation")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }

            NavigationLink(destination: ReminderSettingsView()) {
                Text("Reminders")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.orange)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }

            NavigationLink(destination: QuoteLibraryView()) {
                Text("Quote Library")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.purple)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
        .padding()
        .navigationTitle("Home")
    }
}

struct DailyQuoteView: View {
    @EnvironmentObject var quoteManager: QuoteManager

    var body: some View {
        VStack(spacing: 15) {
            Text("Today's Meditation Quote")
                .font(.headline)
                .foregroundColor(.secondary)

            Text("\"\(quoteManager.currentQuote.text)\"")
                .font(.title3)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            Text("— \(quoteManager.currentQuote.author)")
                .font(.subheadline)
                .italic()
                .foregroundColor(.secondary)

            Button(action: {
                quoteManager.refreshQuote()
            }) {
                Label("New Quote", systemImage: "arrow.clockwise")
                    .padding(.vertical, 8)
                    .padding(.horizontal, 16)
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(8)
            }
            .padding(.top, 5)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemBackground))
                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
        )
        .padding(.horizontal)
    }
}

struct QuoteLibraryView: View {
    @StateObject private var quoteManager = QuoteManager()

    var body: some View {
        List {
            ForEach(quoteManager.quotes) { quote in
                VStack(alignment: .leading, spacing: 8) {
                    Text("\"\(quote.text)\"")
                        .font(.body)

                    Text("— \(quote.author)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding(.vertical, 4)
            }
        }
        .navigationTitle("Quote Library")
    }
}

// MARK: - Audio Player for Meditation
class AudioManager: ObservableObject {
    var audioPlayer: AVAudioPlayer?
    @Published var volume: Float = 0.7
    @Published var selectedSound: MeditationSound = .rain

    enum MeditationSound: String, CaseIterable, Identifiable {
        case rain = "Rain"
        case forest = "Forest"
        case waves = "Ocean Waves"
        case whiteNoise = "White Noise"
        case bowls = "Singing Bowls"

        var id: String { self.rawValue }

        var filename: String {
            switch self {
            case .rain: return "rain"
            case .forest: return "forest"
            case .waves: return "ocean"
            case .whiteNoise: return "whitenoise"
            case .bowls: return "bowls"
            }
        }
    }

    func playSound() {
        // In a real app, you would have actual sound files in your assets
        // Since we can't include real sound files, this is a simulation
        // Replace the URL with an actual file URL in a real implementation

        // Note: In a real app, you would use:
        // if let soundURL = Bundle.main.url(forResource: selectedSound.filename, withExtension: "mp3") {

        // For demonstration purposes with no actual sound files:
        simulateAudioPlayback()
    }

    private func simulateAudioPlayback() {
        // This is just a placeholder for the real implementation
        // In a real app, you would create an AVAudioPlayer with an actual file
        print("Playing \(selectedSound.rawValue) sound at volume \(volume)")

        // Configure audio session for background playback
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Failed to set up audio session: \(error)")
        }
    }

    func stopSound() {
        audioPlayer?.stop()
        print("Stopping \(selectedSound.rawValue) sound")
    }

    func setVolume(_ newVolume: Float) {
        volume = newVolume
        audioPlayer?.volume = newVolume
        print("Volume set to \(newVolume)")
    }
}

struct SessionPlayerView: View {
    @State private var isPlaying = false
    @State private var progress: Float = 0.0
    @State private var timeRemaining = "5:00"
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    let totalSeconds = 300 // 5 minutes
    @State private var elapsedSeconds = 0
    @StateObject private var audioManager = AudioManager()
    @State private var showSoundOptions = false

    var body: some View {
        VStack(spacing: 30) {
            Text("5-Minute Calm Meditation")
                .font(.title2)

            // Selected sound indicator
            HStack {
                Image(systemName: "speaker.wave.2.fill")
                    .foregroundColor(.blue)
                Text(audioManager.selectedSound.rawValue)
                    .foregroundColor(.secondary)

                Button(action: {
                    showSoundOptions.toggle()
                }) {
                    Image(systemName: "chevron.down")
                        .rotationEffect(Angle(degrees: showSoundOptions ? 180 : 0))
                        .foregroundColor(.blue)
                }
            }
            .padding(.vertical, 5)

            // Sound options (expandable)
            if showSoundOptions {
                VStack(spacing: 20) {
                    Picker("Sound", selection: $audioManager.selectedSound) {
                        ForEach(AudioManager.MeditationSound.allCases) { sound in
                            Text(sound.rawValue).tag(sound)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding(.horizontal)

                    HStack {
                        Image(systemName: "speaker.fill")
                        Slider(value: $audioManager.volume, in: 0...1)
                        Image(systemName: "speaker.wave.3.fill")
                    }
                    .padding(.horizontal)
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color(.systemGray6))
                )
                .padding(.horizontal)
            }

            // Progress ring
            ZStack {
                Circle()
                    .stroke(lineWidth: 20)
                    .opacity(0.3)
                    .foregroundColor(Color.blue)

                Circle()
                    .trim(from: 0.0, to: CGFloat(min(self.progress, 1.0)))
                    .stroke(style: StrokeStyle(lineWidth: 20, lineCap: .round, lineJoin: .round))
                    .foregroundColor(Color.blue)
                    .rotationEffect(Angle(degrees: 270.0))
                    .animation(.linear, value: progress)

                VStack {
                    Image(systemName: isPlaying ? "pause.circle.fill" : "play.circle.fill")
                        .resizable()
                        .frame(width: 70, height: 70)
                        .foregroundColor(.blue)
                        .onTapGesture {
                            isPlaying.toggle()

                            if isPlaying {
                                audioManager.playSound()
                            } else {
                                audioManager.stopSound()
                            }
                        }

                    Text(timeRemaining)
                        .font(.title3)
                        .padding(.top, 10)
                }
            }
            .frame(width: 250, height: 250)

            Text(isPlaying ? "Now Playing..." : "Paused")
                .foregroundColor(.secondary)
                .onReceive(timer) { _ in
                    if isPlaying && elapsedSeconds < totalSeconds {
                        elapsedSeconds += 1
                        self.progress = Float(elapsedSeconds) / Float(totalSeconds)

                        let remaining = totalSeconds - elapsedSeconds
                        let minutes = remaining / 60
                        let seconds = remaining % 60
                        timeRemaining = String(format: "%d:%02d", minutes, seconds)

                        if elapsedSeconds == totalSeconds {
                            isPlaying = false
                            audioManager.stopSound()

                            // Reset after completion
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                self.progress = 0.0
                                self.elapsedSeconds = 0
                                self.timeRemaining = "5:00"
                            }
                        }
                    }
                }
        }
        .padding()
        .navigationTitle("Meditation")
        .onDisappear {
            // Make sure to stop sounds if user navigates away
            if isPlaying {
                audioManager.stopSound()
                isPlaying = false
            }
        }
    }
}

struct ReminderSettingsView: View {
    @State private var reminderOn = false
    @State private var selectedFrequency: NotificationFrequency = .daily
    @State private var reminderTime = Date()

    var body: some View {
        Form {
            Section(header: Text("Notification Settings")) {
                Toggle("Daily Meditation Reminder", isOn: $reminderOn)

                if reminderOn {
                    DatePicker("Time", selection: $reminderTime, displayedComponents: .hourAndMinute)

                    Picker("Frequency", selection: $selectedFrequency) {
                        ForEach(NotificationFrequency.allCases) { frequency in
                            Text(frequency.rawValue).tag(frequency)
                        }
                    }

                    Button("Save Reminder Settings") {
                        NotificationManager.shared.scheduleNotification(
                            time: reminderTime,
                            frequency: selectedFrequency
                        )
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    .foregroundColor(.blue)
                    .padding(.vertical, 8)
                }
            }

            Section(header: Text("Quote Notifications")) {
                Text("You'll receive mindfulness quotes at your specified times to help you remember to pause and breathe throughout your day.")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .navigationTitle("Reminders")
    }
}

#Preview {
    ContentView()
}
