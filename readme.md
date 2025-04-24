Original App Design Project - README Template
===

# Meditation App

## Table of Contents

1. [Overview](#Overview)
2. [Product Spec](#Product-Spec)
3. [Schema](#Schema)

## Overview

## Preview

<div>
    <a href="https://www.loom.com/share/0abe31a682f042f0980fa2fad42653d8">
    </a>
    <a href="https://www.loom.com/share/0abe31a682f042f0980fa2fad42653d8">
      <img style="max-width:300px;" src="https://cdn.loom.com/sessions/thumbnails/0abe31a682f042f0980fa2fad42653d8-007ff1afd47c0c47-full-play.gif">
    </a>
  </div>

### Description

Offers short guided meditations and breathing exercises to help users relax, focus, or sleep.

### App Evaluation

Category: Health & Wellness

Mobile:
	•	Push notifications for daily mindfulness reminders.
	•	Audio-based experience fits mobile use.
	•	Potential for using the microphone for breath sensors or logging.

Story:
	•	Clear value: helps reduce stress, improves focus, and supports mental health.
	•	Highly relevant to students, young professionals, or anyone with a busy schedule.
	•	Friends and peers are likely to respond positively, especially if the app is simple and low-pressure.

Market:
	•	Broad but competitive. A stripped-down version could target a specific niche (e.g., “5-minute meditations for students”).
	•	Mental wellness apps are growing in popularity; a focus on quick meditations gives it a unique edge.

Habit:
	•	Could become part of a user’s morning or bedtime routine.
	•	Encourages repeat use through streaks, favorites, and playlists.

Scope:
	•	V1: Includes 3–5 preloaded meditations, timer, and calming background sounds.
	•	V2: Add personalization, streak tracking, and breathing guides.
	•	Very achievable within a short dev cycle.
    


## Product Spec

### 1. User Stories (Required and Optional)

**Required Must-have Stories**
	• User can sign up or log in
	• User can play a guided meditation session
	• User receives daily meditation reminders via push notifications


**Optional Nice-to-have Stories**
	•	User can track their meditation streaks and time spent meditating
	•	User can choose different ambient background sounds
	•	User can favorite and download sessions for offline use

### 2. Screen Archetypes

- Login / Registration Screen (First)
→ User logs in or signs up
- Home Screen (Dashboard - Second)
→ View featured meditations, continue last session, access reminders
- Session Player Screen (Third)
→ Plays selected meditation with play/pause controls and audio

### 3. Navigation

**Tab Navigation** (Tab to Screen)
	•	Home
	•	Sessions
	•	Reminders
	•	Optional: Progress

**Flow Navigation** (Screen to Screen)
	•	Login Screen
→ Home
	•	Registration Screen
→ Home
	•	Home
→ Session Player
→ Reminder Settings
→ (Optional) Progress


## Schema 

[This section will be completed in Unit 9]

### Networking
The meditation app uses Parse for backend functionality across key screens. On the login/registration screen, it performs Parse.User.logIn("username", "password") to authenticate users and Parse.User.signUp() for new user registration. The home screen fetches meditation sessions using a query on the MeditationSession class. When a user selects a session, the session player screen retrieves detailed content via query.get("objectId"). The reminder settings screen uses a query on the Reminder class to fetch user-specific reminders and updates them with reminder.set() and reminder.save(). Optionally, on the progress screen, session logs are pulled from the MeditationLog class using query.find() and new sessions are logged using Parse.Object("MeditationLog").save(). All network interactions are handled with Parse queries and object operations tailored to each screen’s data needs.
