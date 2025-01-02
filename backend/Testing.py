import cv2
import numpy as np
import mediapipe as mp
from tensorflow.keras.models import load_model
import time
from chatgpt_integration import generate_sentence_from_gestures  # ChatGPT entegrasyonu

# Initialize MediaPipe Hands
mp_hands = mp.solutions.hands
mp_drawing = mp.solutions.drawing_utils

# Load the trained LSTM model
model_path = "/Users/yarenuyaroglu/Desktop/ElectiveDesignSignLanguage/lstm_sign_language_model.keras"
model = load_model(model_path)
print("Model successfully loaded!")

# Define categories (labels)
categories = [
    "Anne", "Arkadas", "Baba", "Dur", "Ev", "Evet", "Hayir", "Kardes",
    "Merhaba", "Nasil", "Nerede", "Ozur-Dilemek", "Tamam", "Telefon",
    "Tesekkurler", "Tuvalet", "Yemek", "icmek", "iyi", "kotu"
]

# Start the webcam
cap = cv2.VideoCapture(0)

# Algılama gecikmesi (saniye cinsinden) - Gecikmeyi arttırdık
detection_delay = 2.0  # Her algılamadan sonra 2 saniye bekle
last_detection_time = time.time()

detected_gestures = []


# MediaPipe Hands settings
with mp_hands.Hands(static_image_mode=False,
                    max_num_hands=2,
                    min_detection_confidence=0.5,
                    min_tracking_confidence=0.5) as hands:
    while cap.isOpened():
        ret, frame = cap.read()
        if not ret:
            print("Unable to access the camera.")
            break

        # Flip the image for a mirror effect
        frame = cv2.flip(frame, 1)
        frame_rgb = cv2.cvtColor(frame, cv2.COLOR_BGR2RGB)

        # Process the image with MediaPipe
        results = hands.process(frame_rgb)

        landmarks = []
        if results.multi_hand_landmarks:
            for hand_landmarks in results.multi_hand_landmarks:
                # Extract key points
                hand_data = [
                    lm.x for lm in hand_landmarks.landmark
                ] + [
                    lm.y for lm in hand_landmarks.landmark
                ] + [
                    lm.z for lm in hand_landmarks.landmark
                ]
                landmarks.extend(hand_data)  # Combine data for two hands

                # Draw key points
                mp_drawing.draw_landmarks(
                    frame, hand_landmarks, mp_hands.HAND_CONNECTIONS)

        # Algılama işlemi (zaman kontrolü ekliyoruz)
        if landmarks and time.time() - last_detection_time > detection_delay:
            try:
                # Adjust to model input dimensions
                if len(landmarks) == 63:  # Single hand (21 points)
                    landmarks = np.array(landmarks).reshape(1, 21, 3)
                elif len(landmarks) == 126:  # Two hands (42 points)
                    landmarks = np.array(landmarks).reshape(1, 42, 3)
                else:
                    print("Unexpected number of key points.")
                    continue

                # Class prediction
                predictions = model.predict(landmarks)
                predicted_class = categories[np.argmax(predictions)]
                confidence = np.max(predictions)

                # Display predictions with a confidence threshold
                if confidence > 0.7:  # Only display if confidence > 70%
                    detected_gestures.append(predicted_class)
                    print(f"Algılanan Jest: {predicted_class} ({confidence:.2f})")
                    last_detection_time = time.time()  # Algılamayı geciktirmek için zamanı güncelle

            except Exception as e:
                print(f"Error during prediction: {e}")

        # Show the frame
        cv2.imshow('Sign Language Detection', frame)

        # Exit with 'q'
        if cv2.waitKey(1) & 0xFF == ord('q'):
            break

        # Add sleep for better processing time (Optional)
        time.sleep(0.1)  # Add a small delay to control the frame rate

cap.release()  # Kamerayı serbest bırak
cv2.destroyAllWindows()

# Algılanan jestleri ChatGPT'ye gönder ve anlamlı bir cümle oluştur
if detected_gestures:
    print("Algılanan Jestler:", detected_gestures)
    sentence = generate_sentence_from_gestures(detected_gestures)
    print("Anlamlı Cümle:", sentence)
else:
    print("Hiçbir jest algılanmadı.")