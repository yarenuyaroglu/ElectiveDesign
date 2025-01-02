# ElectiveDesign
Graduation project for Elective Design: A mobile app that translates Turkish Sign Language (TSL) into meaningful text using YOLOv8 or CNN models. Integrates ChatGPT API for sentence formation and Google Speech-to-Text API. Built with Flutter, enabling seamless video call communication for TSL users.

## Dataset
The dataset used in this project is the **Turkish Sign Language Dataset** provided by [Roboflow](https://roboflow.com). 
You can access the dataset from the following link:
    [Download Dataset](https://universe.roboflow.com/proje-qtjgs/turk-isaret-dili/dataset/2)
    

## Project Milestones
- **15 November 2024**: TÜBİTAK application submitted for the project.

- Real-Time-BAsed Sign Language Detection

📖 Project Overview

This project focuses on detecting sign language gestures and converting them into meaningful text using MediaPipe for gesture recognition. Additionally, it integrates ChatGPT to enhance text output. The system supports video-based communication where sign language gestures are recognized in real-time.

📂 Project Directory Structure
SignLanguageDemo/
├── backend/                  # Backend code (Flask-based)
│   ├── server.py             # Flask main server file
│   ├── config.json           # API keys
│   ├── requirements.txt      # Python dependencies
│   ├── chatgpt_integration.py # ChatGPT API integration
│   ├── Testing.py            # MediaPipe testing script
│   └── ElectiveSignLanguage.ipynb  # Colab notebook for model training
├── frontend/                 # Frontend code (Swift-based)
│   ├── CameraView.swift      # Camera management
│   ├── ContentView.swift     # App entry point UI
│   ├── SignLanguageView.swift# UI for gesture processing
│   ├── VideoCallView.swift   # Video call feature
│   ├── SignLanguageDetectionApp.swift # Main application file
│   └── Info.plist            # iOS app configuration
└── README.md                 # Project documentation


🚀 Features
	•	Sign Language Detection: Real-time gesture detection using MediaPipe.
	•	ChatGPT Integration: Converts gestures into meaningful sentences.
	•	Video Call Support: Recognizes sign language gestures during video calls.
	•	Local Testing: MediaPipe-powered gesture recognition testing.
	•	Model Training in Colab: Use the Colab notebook for model training and testing.


🛠️ Technologies Used
	•	Backend:
	•	Flask
	•	TensorFlow / Keras
	•	MediaPipe (gesture recognition)
	•	OpenAI ChatGPT API
	•	Frontend:
	•	Swift (iOS application development)

Dataset
The dataset used in this project is the Turkish Sign Language Dataset provided by Roboflow. You can access the dataset from the following link: [Download Dataset](https://universe.roboflow.com/proje-qtjgs/turk-isaret-dili/dataset/2)

📝 Installation and Setup

1️⃣ Prerequisites

Backend
	•	Python 3.9+
	•	Flask and dependencies (install via requirements.txt):
    pip install -r requirements.txt

Frontend
	•	Xcode with Swift 5.0+

2️⃣ Clone the Project

Clone or download the project:
git clone [https://github.com](https://github.com/yarenuyaroglu/ElectiveDesign.git)

3️⃣ Run the Backend
	1.	Navigate to the backend/ directory.
	2.	Start the Flask server:
    python server.py
	3.	The server will run at http://127.0.0.1:5003.

4️⃣ Run the Frontend
	1.	Open the Swift files in the frontend/ folder using Xcode.
	2.	Verify the backend URL in your Swift code:
    let serverURL = "http://127.0.0.1:5003/process_frame"
    3.	Run the application on a simulator or a real device.


📋 Notes and Suggestions
	•	API Keys: Add your OpenAI API key in the backend/config.json file.
    •	Local Testing: Use Testing.py to test gesture detection with MediaPipe locally.


