import SwiftUI

struct SignLanguageView: View {
    @State private var detectedText: String = "Waiting for input..."
    @State private var receivedMessage: String = "No message received yet."
    @State private var isCameraActive: Bool = true
    @State private var isProcessing: Bool = false

    var body: some View {
        VStack(spacing: 20) {
            // Title
            Text("Sign Language Mode")
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(.purple)
                .padding(.top, 10)

            // Camera Feed
            if isCameraActive {
                CameraView(detectedSentence: $detectedText)
                    .frame(height: 430)
                    .cornerRadius(15)
                    .shadow(radius: 10)
                    .padding(.horizontal)
            } else {
                Text("Camera is off")
                    .font(.headline)
                    .foregroundColor(.red)
                    .frame(height: 300)
                    .background(Color.black.opacity(0.1))
                    .cornerRadius(15)
            }

            // Detected Text from Flask
            Text(detectedText)
                .font(.body)
                .multilineTextAlignment(.center)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)
                .shadow(radius: 5)

            // Message from Other Side
            Text(receivedMessage)
                .font(.body)
                .multilineTextAlignment(.center)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.green.opacity(0.2))
                .cornerRadius(10)
                .shadow(radius: 5)

            Spacer()

            // Control Buttons
            HStack(spacing: 20) {
                Button(action: {
                    startDetection()
                }) {
                    HStack {
                        if isProcessing {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle())
                        }
                        Text("Start Detection")
                    }
                    .font(.title3)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }

                Button(action: {
                    isCameraActive.toggle()
                }) {
                    Text(isCameraActive ? "Stop Camera" : "Start Camera")
                        .font(.title3)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.orange)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }

                Button(action: {
                    endCall()
                }) {
                    Text("End Call")
                        .font(.title3)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            .padding(.horizontal)

            Spacer()
        }
        .padding()
        .background(Color.blue.opacity(0.1).ignoresSafeArea())
    }

    // Start Detection
    private func startDetection() {
        guard isCameraActive else {
            detectedText = "Camera is not active."
            return
        }

        isProcessing = true
        detectedText = "Sending data to Flask API..."

        sendGesturesToFlask(gestures: ["Hello", "Goodbye"]) { response in
            DispatchQueue.main.async {
                isProcessing = false
                if let response = response {
                    detectedText = response
                } else {
                    detectedText = "Failed to get a response from the server."
                }
            }
        }
    }

    // Send Gestures to Flask
    private func sendGesturesToFlask(gestures: [String], completion: @escaping (String?) -> Void) {
        guard let url = URL(string: "http://10.91.117.166:5003/process_frame") else {
            completion("Invalid server URL.")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let body: [String: Any] = ["gestures": gestures]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                completion("Error: \(error.localizedDescription)")
                return
            }

            if let data = data,
               let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
               let sentence = json["sentence"] as? String {
                completion(sentence)
            } else {
                completion("Invalid response from server.")
            }
        }.resume()
    }
    
    // End Call
    private func endCall() {
        detectedText = "Call ended."
        receivedMessage = "No active call."
        isCameraActive = false
    }
}
