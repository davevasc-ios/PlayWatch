//
//  ContentView.swift
//  PlayWatch
//
//  Created by David on 17/3/24.
//

import SwiftUI


struct ContentView: View {
    
    @State var result = "result"
    
    func apiGeminiCall() {
        guard let url = URL(string: "https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent?key=\(APIKey.gemini)") else {
            return
        }
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        request.setValue ("application/json", forHTTPHeaderField: "Content-Type")
        let body: [String: AnyHashable] = [
            "contents": [
                [
                    "parts": [
                        [
                            "text": "que idioma es mejor? español o esukera?"
                        ]
                    ]
                ]
            ]
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
        
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            do {
                let response = try JSONSerialization.jsonObject(with: data, options: [])
                print("SUCCESS: \(response)")
            } catch {
                print("ERROR: \(error)")
            }
        }
        task.resume()
    }
    
    func apiOpenAICall() {
        guard let url = URL(string: "https://api.openai.com/v1/chat/completions") else {
            return
        }
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        request.setValue("Bearer \(APIKey.openAI)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = [
            "model": "gpt-3.5-turbo",
            "messages": [
                [
                    "role": "system",
                    "content": "Eres un asistente experto en contar cuentos para niños"
                ],
                [
                    "role": "user",
                    "content": "Cuéntame una hitoria en idioma Euskera"
                ]
            ]
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            do {
                let response = try JSONSerialization.jsonObject(with: data, options: [])
                print("SUCCESS: \(response)")
            } catch {
                print("ERROR: \(error)")
            }
        }
        task.resume()
    }
    
    func apiTMDBCall() {

        // solo se puede filtrar por ID
        guard let url = URL(string: "https://api.themoviedb.org/3/movie/157336/watch/providers") else {
            return
        }
        // devuelve todos los países, hay que cargar solo el país actual
        
        // solo se puede filtar por ID y lengua
        guard let url2 = URL(string: "https://api.themoviedb.org/3/movie/157336/videos?language=fr-FR") else {
            return
        }
        // Obtener youtube key. name = 'XXX', key = 'key', site = 'Youtube', trailer, Type = `Trailer`, official = true
        ///https://api.themoviedb.org/3/movie/\(id)/videos?language=\(es-ES)
    ///https://www.youtube.com/watch?v=\(key)
        /// Poster, parámetro 'poster_path`
        /// https://image.tmdb.org/t/p/w500/ykZ7hlShkdRQaL2aiieXdEMmrLb.jpg
        
        var request = URLRequest(url: url)
    
        request.httpMethod = "GET"
        request.setValue("Bearer \(APIKey.movieDB)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "accept")
                
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data = data, error == nil else {
                print(error as Any)
                return
            }
            do {
                let result = try JSONSerialization.jsonObject(with: data, options: [])
                print("RESULT: \(result)")
            } catch {
                print("ERROR: \(error)")
            }
        }
        task.resume()
    }
    
    
    var body: some View {
        VStack {
            Text("Start Gemini")
            Button(action: {
                Task {
//                    apiGeminiCall()
//                    apiTMDBCall()
                    apiOpenAICall()
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
