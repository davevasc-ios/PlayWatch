//
//  MockData.swift
//  PlayWatch
//
//  Created by David on 16/5/24.
//

import Foundation

struct MockData {
    
    static var emptyGameQuiz: GameQuiz {
        GameQuiz(movie: self.movie,
                 quiz: self.question)
    }
    
    static var gameQuiz: [GameQuiz] {
        var gameQuiz: [GameQuiz] = []
        for i in 0..<3 {
            gameQuiz.append(GameQuiz(movie: self.movies[i], quiz: self.questions[i]))
        }
        return gameQuiz
    }
    
    static let question: Quiz = .init(question: "¿Cuál es la trama principal de la película?", result: false)
    
    static let questions: [Quiz] = [
        .init(question: "¿Cuál es la trama principal de la película?", result: false),
        .init(question: "¿Quién fue el director de esta película?", result: true),
        .init(question: "Describe el personaje principal de esta película.", result: false),
        .init(question: "¿En qué año se estrenó esta película?", result: true),
        .init(question: "¿Qué género cinematográfico mejor describe esta película?", result: false),
        .init(question: "¿Qué actor interpretó el papel principal?", result: true),
        .init(question: "¿Qué premios ganó esta película?", result: false),
        .init(question: "¿Quién escribió el guion de esta película?", result: true),
        .init(question: "¿Dónde se desarrolla la trama principal de esta película?", result: false),
        .init(question: "¿Cuál es la duración de esta película?", result: true),
        .init(question: "¿Cómo se llama la banda sonora de esta película?", result: false),
        .init(question: "¿Qué críticas recibió esta película de los espectadores?", result: true),
        .init(question: "¿Cuál fue el presupuesto de producción de esta película?", result: false),
        .init(question: "¿Qué efectos especiales se utilizaron en esta película?", result: true),
        .init(question: "¿Cuál fue la inspiración detrás de esta película?", result: false),
        .init(question: "¿Cuál es la escena más memorable de esta película?", result: true),
        .init(question: "¿Qué temas importantes aborda esta película?", result: false),
        .init(question: "¿Qué impacto tuvo esta película en la cultura popular?", result: true),
        .init(question: "¿Qué otras películas se parecen a esta?", result: false),
        .init(question: "¿Cuál es el mensaje central de esta película?", result: true)
    ]
    
    static let movie: Media = .init(id: 1,
                                    type: .movie,
                                    image: "https://image.tmdb.org/t/p/w500/6tJWxRfBKWGIPFkfLTod2CgCexU.jpg",
                                    name: "Movie 1",
                                    date: MovieDB.getDate(date: "2023-05-15"),
                                    rating: 7.5)
    
    static let movies: [Media] = [
        .init(id: 1,
              type: .movie,
              image: "https://image.tmdb.org/t/p/w500/6tJWxRfBKWGIPFkfLTod2CgCexU.jpg",
              name: "Movie 1",
              date: MovieDB.getDate(date: "2023-05-15"),
              rating: 7.5),
        .init(id: 1,
              type: .movie,
              image: "https://image.tmdb.org/t/p/w500/6tJWxRfBKWGIPFkfLTod2CgCexU.jpg",
              name: "Movie 2",
              date: MovieDB.getDate(date: "2023-05-15"),
              rating: 7.5),
        .init(id: 1,
              type: .movie,
              image: "https://image.tmdb.org/t/p/w500/6tJWxRfBKWGIPFkfLTod2CgCexU.jpg",
              name: "Movie 3",
              date: MovieDB.getDate(date: "2023-05-15"),
              rating: 7.5),
        .init(id: 1,
              type: .movie,
              image: "https://image.tmdb.org/t/p/w500/6tJWxRfBKWGIPFkfLTod2CgCexU.jpg",
              name: "Movie 4",
              date: MovieDB.getDate(date: "2023-05-15"),
              rating: 7.5),
        .init(id: 1,
              type: .movie,
              image: "https://image.tmdb.org/t/p/w500/6tJWxRfBKWGIPFkfLTod2CgCexU.jpg",
              name: "Movie 5",
              date: MovieDB.getDate(date: "2023-05-15"),
              rating: 7.5),
        .init(id: 1,
              type: .movie,
              image: "https://image.tmdb.org/t/p/w500/6tJWxRfBKWGIPFkfLTod2CgCexU.jpg",
              name: "Movie 6",
              date: MovieDB.getDate(date: "2023-05-15"),
              rating: 7.5),
    ]
    
}
