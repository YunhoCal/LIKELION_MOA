<div align="center">

# MOA — Meet On App

**A social meetup app for discovering and joining activities around you**

![Swift](https://img.shields.io/badge/Swift-F54A2A?style=for-the-badge&logo=swift&logoColor=white)
![SwiftUI](https://img.shields.io/badge/SwiftUI-0D96F6?style=for-the-badge&logo=swift&logoColor=white)
![Firebase](https://img.shields.io/badge/Firebase-FFCA28?style=for-the-badge&logo=firebase&logoColor=black)
![Node.js](https://img.shields.io/badge/Node.js-339933?style=for-the-badge&logo=nodedotjs&logoColor=white)

</div>

---

## Motivation

Finding activities and meetups near you is harder than it should be. Most people want to study with others, grab a meal, or play a sport — but have no easy way to discover who else is looking for the same thing nearby. Existing platforms are either too large and impersonal, or too niche to be useful day-to-day.

MOA was built to solve exactly that. The idea is simple: **anyone can host an activity, and anyone can join one** — no gatekeeping, no complicated setup. Whether you're a student looking for a study group, someone who doesn't want to eat alone, or just trying to find a pickup soccer game on a Saturday afternoon, MOA puts those opportunities right in front of you based on where you are.

---

## What is MOA?

MOA (Meet On App) is an iOS application that makes it easy to create, discover, and join local social activities in real time. Users can browse activities around them filtered by category, see who's hosting and how many spots are left, and join with a single tap. Hosts can create events in seconds with a location, time, category, and capacity — and MOA handles the rest.

The goal is to lower the barrier for spontaneous social connection. No formal groups, no membership required — just open activities that anyone nearby can find and join.

---

## Screenshots

| Login | Home | Activity Details |
|:---:|:---:|:---:|
| <img src="docs/screenshots/01_login.jpeg" width="200"/> | <img src="docs/screenshots/02_home.jpeg" width="200"/> | <img src="docs/screenshots/03_activity_details.jpeg" width="200"/> |

| My Events | Calendar | Calendar (Date View) |
|:---:|:---:|:---:|
| <img src="docs/screenshots/04_my_events.jpeg" width="200"/> | <img src="docs/screenshots/05_calendar_1.jpeg" width="200"/> | <img src="docs/screenshots/06_calendar_2.jpeg" width="200"/> |

---

## Features

- **Authentication** — Email/password sign-in and sign-up with Firebase Auth
- **Home Feed** — Browse trending activities filtered by category (Study, Meal Buddy, Sports, Others)
- **Activity Details** — View event info (time, location, host, participants) and join with one tap
- **Create Activity** — Post a new meetup with category, location, time, and capacity
- **My Events** — Track events you are hosting and events you have joined, with real-time spot counts
- **Calendar View** — Visualize all nearby or personal activities on a monthly calendar with date-based filtering

---

## Tech Stack

| Layer | Technology |
|---|---|
| iOS Frontend | Swift, SwiftUI |
| Authentication | Firebase Authentication |
| Database | Firebase Firestore |
| Backend API | Node.js, Express |
| Infrastructure | Docker |
| Version Control | Git, GitHub |
| IDE | Xcode |

---

## Project Structure

```
├── likelion/                    # iOS SwiftUI application
│   ├── MOAApp.swift             # App entry point
│   ├── FirebaseService.swift    # Firebase Firestore integration
│   ├── APIService.swift         # REST API service layer
│   ├── HomeView.swift           # Home feed
│   ├── CalendarTabView.swift    # Calendar view
│   ├── CreateActivityView.swift # Event creation flow
│   ├── LoginView.swift          # Authentication UI
│   └── ...
├── moa-backend/                 # Node.js backend server
│   ├── server.js                # Express server entry point
│   ├── routes/                  # API route handlers
│   ├── middleware/               # Auth and request middleware
│   └── docker-compose.yml       # Docker configuration
└── docs/
    └── screenshots/             # App screenshots
```

---

## Future Improvements

- Search and location-based filtering for nearby activities
- Push notifications for activity updates and join confirmations
- User profile customization and interest tagging
- Real-time chat within activity groups
- Enhanced UI consistency and animation polish

---

<div align="center">
  <sub>Built by <a href="mailto:yunhochoi27@gmail.com">Yunho Choi</a></sub>
</div>
