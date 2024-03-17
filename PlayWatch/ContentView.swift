//
//  ContentView.swift
//  PlayWatch
//
//  Created by David on 17/3/24.
//

import SwiftUI
//import SwiftData
import GoogleGenerativeAI

struct ContentView: View {
    
    @State var result = "result"
    let model = GenerativeModel(name: "gemini-pro", apiKey: GeminiAPIKey.default)
    
    func generateOutput() async {
        let prompt = "Write a story about a magic backpack"
        do {
            let response = try await model.generateContent(prompt)
            if let text = response.text {
                result = text
            }
        } catch {
            print("Catch error: \(error.localizedDescription)")
            print("key: \(GeminiAPIKey.default)")
        }
    }
    
    var body: some View {
        VStack {
            Text("Start Gemini")
            Button(action: {
                Task {
                    await generateOutput()
                }
            }) {
                  Text("texto")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
                }
            Text(result)
        }
    }
    
}

#Preview {
    ContentView()
//        .modelContainer(for: Item.self, inMemory: true)
}
