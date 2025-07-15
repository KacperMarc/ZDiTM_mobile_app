# ZDiTM_mobile_app

Developing mobile application of ZDiTM public transport carrier.

This project is about to wrap three key features, that various apps can offer, but none of those contains all of them in one place like enabling users to check real-time departure schedules, track the live location of buses and trams, and plan optimal routes from one stop to another also enabling ticket purchase.

# 🔑 Key Features

* Timetable Lookup
* Vehicle Tracking
* Route Search
* Ticket Purchase

# 🚀 Technologies Used

* Swift, UIKit 
* EnvironmentObject implementation from SwiftUI
* Combine framework – for reactive programming and managing asynchronous data streams
* RESTful API integration – for fetching and parsing public transit data (vehicles, lines, stops, trajectories)
* Swift Concurrency (async/await) – for performing network calls and background updates
* MapKit – for rendering and clustering annotations of vehicles and stops on the map

# 🔧 Architecture & Navigation

 The application follows the MVVM (Model-View-ViewModel) architectural pattern, ensuring a clean separation of concerns and easier testability and maintainability. Certain ViewModels are reused across the app, mapViewModel for instance.

# 📷 Showcase

<img width="1187" height="715" alt="image" src="https://github.com/user-attachments/assets/bd8c3211-edc2-488b-9773-05232fd03f39" />
<img width="1185" height="713" alt="image" src="https://github.com/user-attachments/assets/c32cb117-ba0d-41c4-84c5-687763a5828d" />
<img width="1188" alt="image" src="https://github.com/user-attachments/assets/569cba58-3811-4a05-87a8-2edf323ce95c" />

# More 
Project website: https://devshowcase-gamma.vercel.app/#projects
