//
//  ContentView.swift
//  MeditatinoApp
//
//  Created by neo on 4/24/25.
//

import SwiftUI

struct ContentView: View {
    @State private var isLoggedIn = false
    @State private var username = ""
    @State private var password = ""

    var body: some View {
        NavigationView {
            if isLoggedIn {
                HomeView()
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
    var body: some View {
        VStack(spacing: 20) {
            Text("Welcome Back!")
                .font(.title)

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
        }
        .padding()
        .navigationTitle("Home")
    }
}

struct SessionPlayerView: View {
    @State private var isPlaying = false

    var body: some View {
        VStack(spacing: 30) {
            Text("5-Minute Calm Meditation")
                .font(.title2)

            Image(systemName: isPlaying ? "pause.circle.fill" : "play.circle.fill")
                .resizable()
                .frame(width: 100, height: 100)
                .onTapGesture {
                    isPlaying.toggle()
                }

            Text(isPlaying ? "Now Playing..." : "Paused")
        }
        .padding()
        .navigationTitle("Meditation")
    }
}

struct ReminderSettingsView: View {
    @State private var reminderOn = false

    var body: some View {
        Form {
            Toggle("Daily Meditation Reminder", isOn: $reminderOn)
        }
        .navigationTitle("Reminders")
    }
}

#Preview {
    ContentView()
}
