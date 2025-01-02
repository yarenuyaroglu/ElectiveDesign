import SwiftUI

enum CallType {
    case voice
    case signLanguage
}

struct VideoCallView: View {
    let callType: CallType

    @Environment(\.presentationMode) var presentationMode
    @State private var detectedText: String = "Waiting for detection..."
    @State private var isProcessing: Bool = false
    @State private var isCameraOn: Bool = true
    @State private var isMicOn: Bool = true

    var body: some View {
        VStack(spacing: 20) {
            Text(callType == .voice ? "Voice Call" : "Sign Language Call")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()

            Spacer()

            ZStack {
                if isCameraOn {
                    Rectangle()
                        .fill(Color.black.opacity(0.8))
                        .frame(height: 300)
                        .cornerRadius(15)
                        .overlay(
                            Text("Camera View")
                                .foregroundColor(.white)
                                .font(.title)
                        )
                } else {
                    Rectangle()
                        .fill(Color.gray.opacity(0.6))
                        .frame(height: 300)
                        .cornerRadius(15)
                        .overlay(
                            Text("Camera is Off")
                                .foregroundColor(.white)
                                .font(.title)
                        )
                }
            }

            Spacer()

            // Detection Result Area
            VStack(alignment: .leading, spacing: 10) {
                Text("Detected Text:")
                    .font(.headline)
                    .padding(.bottom, 5)

                ScrollView {
                    Text(detectedText)
                        .font(.body)
                        .foregroundColor(.primary)
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(10)
                        .shadow(radius: 5)
                }
                .frame(height: 100)
            }
            .padding()

            HStack(spacing: 20) {
                Button(action: {
                    isMicOn.toggle()
                }) {
                    Image(systemName: isMicOn ? "mic.fill" : "mic.slash.fill")
                        .font(.title)
                        .padding()
                        .background(isMicOn ? Color.blue : Color.red)
                        .foregroundColor(.white)
                        .clipShape(Circle())
                }

                Button(action: {
                    isCameraOn.toggle()
                }) {
                    Image(systemName: isCameraOn ? "video.fill" : "video.slash.fill")
                        .font(.title)
                        .padding()
                        .background(isCameraOn ? Color.green : Color.red)
                        .foregroundColor(.white)
                        .clipShape(Circle())
                }

                Button(action: {
                    endCall()
                }) {
                    Image(systemName: "phone.down.fill")
                        .font(.title)
                        .padding()
                        .background(Color.red)
                        .foregroundColor(.white)
                        .clipShape(Circle())
                }
            }
            .padding(.horizontal)
        }
        .padding()
        .onAppear {
            startProcessing()
        }
    }

    func startProcessing() {
        isProcessing = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            if callType == .voice {
                detectedText = "You said: 'Hello, how are you?'"
            } else {
                detectedText = "Your sign means: 'Thank you!'"
            }
            isProcessing = false
        }
    }

    func endCall() {
        presentationMode.wrappedValue.dismiss()
    }
}
