import SwiftUI
import AVFoundation

struct VoiceCallView: View {
    @State private var detectedText: String = "Voice call initiated..."
    @State private var isDetecting: Bool = false

    var body: some View {
        VStack {
            // Kamera Görüntüsü
            CameraView(detectedSentence: $detectedText)
                .frame(height: 500) // Kamerayı geniş bir şekilde gösteriyoruz
                .cornerRadius(20)
                .shadow(radius: 10)
                .padding()

            Spacer()

            // Durum Mesajı
            Text(detectedText)
                .font(.title2)
                .multilineTextAlignment(.center)
                .padding()
                .foregroundColor(.primary)

            // Algılama Başlat Butonu
            Button(action: {
                isDetecting = true
                detectedText = "Camera is active for voice call..."
                
                // Gerekli işlemler burada yapılır
                DispatchQueue.global(qos: .userInitiated).async {
                    // Kameradan görüntü işleme vb. yapılabilir
                    
                    DispatchQueue.main.async {
                        isDetecting = false
                    }
                }
            }) {
                HStack {
                    Image(systemName: "mic.fill")
                    Text("Start Camera")
                }
                .font(.title2)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
            }

            Spacer()
        }
        .padding()
    }
}
