import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                Text("How Do You Want to Join?")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .padding(.top, 50)

                // Voice Call Button
                NavigationLink(destination: VoiceCallView()) {
                    VStack {
                        Image(systemName: "mic.fill")
                            .font(.system(size: 80))
                            .foregroundColor(.blue)
                        Text("Join with Voice")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(.blue)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue.opacity(0.15))
                    .cornerRadius(20)
                    .shadow(radius: 5)
                }
                .padding(.horizontal)

                // Sign Language Button
                NavigationLink(destination: SignLanguageView()) {
                    VStack {
                        Image(systemName: "hands.sparkles.fill")
                            .font(.system(size: 80))
                            .foregroundColor(.green)
                        Text("Join with Sign Language")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(.green)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.green.opacity(0.15))
                    .cornerRadius(20)
                    .shadow(radius: 5)
                }
                .padding(.horizontal)

                Spacer()
            }
            .padding()
            .navigationBarHidden(true)
        }
    }
}
