import SwiftUI
import AVFoundation

struct CameraView: UIViewControllerRepresentable {
    @Binding var detectedSentence: String  // Flask'tan gelen cümle için bağlanabilir değişken

    class Coordinator: NSObject, AVCaptureVideoDataOutputSampleBufferDelegate {
        var parent: CameraView

        init(parent: CameraView) {
            self.parent = parent
        }

        func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
            // Video karelerini işleyip Flask API'ye gönder
            guard let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
            let ciImage = CIImage(cvPixelBuffer: imageBuffer)
            let context = CIContext()
            guard let cgImage = context.createCGImage(ciImage, from: ciImage.extent) else { return }
            let uiImage = UIImage(cgImage: cgImage)
            guard let imageData = uiImage.jpegData(compressionQuality: 0.8) else { return }
            let base64Image = imageData.base64EncodedString()

            sendFrameToFlask(imageBase64: base64Image)
        }

        private func sendFrameToFlask(imageBase64: String) {
            guard let url = URL(string: "http://127.0.0.1:5003/process_frame") else { return }

            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")

            let body: [String: Any] = ["image_b64": imageBase64]
            request.httpBody = try? JSONSerialization.data(withJSONObject: body)

            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("Hata:", error.localizedDescription)
                    return
                }

                if let data = data, let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
                    let sentence = json["sentence"] as? String ?? "Anlamlı cümle bulunamadı."
                    DispatchQueue.main.async {
                        self.parent.detectedSentence = sentence
                    }
                }
            }.resume()
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }

    func makeUIViewController(context: Context) -> UIViewController {
        let controller = UIViewController()
        let captureSession = AVCaptureSession()

        // Kamera cihazını seç
        let videoDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front)
        guard let videoDeviceInput = try? AVCaptureDeviceInput(device: videoDevice!),
              captureSession.canAddInput(videoDeviceInput) else { return controller }
        captureSession.addInput(videoDeviceInput)

        // Video veri çıkışı ekle
        let videoOutput = AVCaptureVideoDataOutput()
        videoOutput.setSampleBufferDelegate(context.coordinator, queue: DispatchQueue(label: "videoQueue"))
        guard captureSession.canAddOutput(videoOutput) else { return controller }
        captureSession.addOutput(videoOutput)

        // Ön izleme katmanı
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.videoGravity = .resizeAspectFill
        previewLayer.frame = controller.view.bounds
        controller.view.layer.addSublayer(previewLayer)
        captureSession.startRunning()

        return controller
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}
