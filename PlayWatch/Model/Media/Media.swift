//
//  Media.swift
//  PlayWatch
//
//  Created by David on 17/12/24.
//

import Foundation

struct Media: Identifiable, Hashable {
    let id: Int
    let type: MovieDBType
    let backdropUrl: URL?
    let imageUrl: URL?
    let name: String
    let date: Date?
    let rating: Double?
}

extension Array where Element == Media {
    var filterWithImage: [Element] {
        self.filter { $0.imageUrl != nil }
    }
    
    func joinedNames(separator: String = .commaSeparator) -> String {
        self.map { $0.name }.joined(separator: separator)
    }
}

extension Optional where Wrapped == [Media] {
    var orEmpty: [Media] {
        self ?? []
    }
}

#if DEBUG
// MARK: - Extensions

extension Media {
    
    // MARK: - Single Movie Preview
    /// Datos reales de "Deadpool & Wolverine" extraídos del JSON.
    static let previewMovie = Media(
        id: 533535,
        type: .movie,
        backdropUrl: MovieDBUtils.getImageURL(file: "/yDHYTfA3R0jFYba16jBB1ef8oIt.jpg", size: .original),
        imageUrl: MovieDBUtils.getImageURL(file: "/8cdWjvZQUExUUTzyp4t6EDMubfO.jpg", size: .small),
        name: "Deadpool & Wolverine",
        date: "2024-07-24".toDate(),
        rating: 7.71
    )
    
    static let previewMovieImageError = Media(
        id: 533535,
        type: .movie,
        backdropUrl: MovieDBUtils.getImageURL(file: "/.jpg", size: .original),
        imageUrl: MovieDBUtils.getImageURL(file: "/.jpg", size: .small),
        name: "Deadpool & Wolverine",
        date: "2024-07-24".toDate(),
        rating: 7.71
    )
    
    // MARK: - Movie List Preview
    /// Lista estática de 20 películas reales.
    /// Al estar hardcodeado, el compilador lo optimiza y el acceso es O(1) inmediato (sin parsing JSON).
    static let previewMovieList: [Media] = [
        Media(
            id: 533535,
            type: .movie,
            backdropUrl: MovieDBUtils.getImageURL(file: "/yDHYTfA3R0jFYba16jBB1ef8oIt.jpg", size: .original),
            imageUrl: MovieDBUtils.getImageURL(file: "/8cdWjvZQUExUUTzyp4t6EDMubfO.jpg", size: .small),
            name: "Deadpool & Wolverine",
            date: "2024-07-24".toDate(),
            rating: 7.71
        ),
        Media(
            id: 365177,
            type: .movie,
            backdropUrl: MovieDBUtils.getImageURL(file: "/mKOBdgaEFguADkJhfFslY7TYxIh.jpg", size: .original),
            imageUrl: MovieDBUtils.getImageURL(file: "/865DntZzOdX6rLMd405R0nFkLmL.jpg", size: .small),
            name: "Borderlands",
            date: "2024-08-07".toDate(),
            rating: 5.88
        ),
        Media(
            id: 917496,
            type: .movie,
            backdropUrl: MovieDBUtils.getImageURL(file: "/18wozP6NjPSNBSgCga5bN7yUSzl.jpg", size: .original),
            imageUrl: MovieDBUtils.getImageURL(file: "/kKgQzkUCnQmeTPkyIwHly2t6ZFI.jpg", size: .small),
            name: "Beetlejuice Beetlejuice",
            date: "2024-09-04".toDate(),
            rating: 7.201
        ),
        Media(
            id: 1022789,
            type: .movie,
            backdropUrl: MovieDBUtils.getImageURL(file: "/stKGOm8UyhuLPR9sZLjs5AkmncA.jpg", size: .original),
            imageUrl: MovieDBUtils.getImageURL(file: "/vpnVM9B6NMmQpWeZvzLvDESb2QY.jpg", size: .small),
            name: "Inside Out 2",
            date: "2024-06-11".toDate(),
            rating: 7.67
        ),
        Media(
            id: 646097,
            type: .movie,
            backdropUrl: MovieDBUtils.getImageURL(file: "/tbgIhYwQ5IAgNaFU1SBBxxNXCmm.jpg", size: .original),
            imageUrl: MovieDBUtils.getImageURL(file: "/xEt2GSz9z5rSVpIHMiGdtf0czyf.jpg", size: .small),
            name: "Rebel Ridge",
            date: "2024-08-27".toDate(),
            rating: 6.92
        ),
        Media(
            id: 519182,
            type: .movie,
            backdropUrl: MovieDBUtils.getImageURL(file: "/lgkPzcOSnTvjeMnuFzozRO5HHw1.jpg", size: .original),
            imageUrl: MovieDBUtils.getImageURL(file: "/wWba3TaojhK7NdycRhoQpsG0FaH.jpg", size: .small),
            name: "Despicable Me 4",
            date: "2024-06-20".toDate(),
            rating: 7.183
        ),
        Media(
            id: 573435,
            type: .movie,
            backdropUrl: MovieDBUtils.getImageURL(file: "/rwakNepsh0dXVcTtWKUVbDsSYYZ.jpg", size: .original),
            imageUrl: MovieDBUtils.getImageURL(file: "/oGythE98MYleE6mZlGs5oBGkux1.jpg", size: .small),
            name: "Bad Boys: Ride or Die",
            date: "2024-06-05".toDate(),
            rating: 7.55
        ),
        Media(
            id: 970347,
            type: .movie,
            backdropUrl: MovieDBUtils.getImageURL(file: "/tCQfubckzzcuCbsGugkpLhfjS5z.jpg", size: .original),
            imageUrl: MovieDBUtils.getImageURL(file: "/6PCnxKZZIVRanWb710pNpYVkCSw.jpg", size: .small),
            name: "The Killer",
            date: "2024-08-22".toDate(),
            rating: 6.569
        ),
        Media(
            id: 923667,
            type: .movie,
            backdropUrl: MovieDBUtils.getImageURL(file: "/9juRmk8QjcsUcbrevVu5t8VZy5G.jpg", size: .original),
            imageUrl: MovieDBUtils.getImageURL(file: "/PywbVPeIhBFc33QXktnhMaysmL.jpg", size: .small),
            name: "Twilight of the Warriors: Walled In",
            date: "2024-04-23".toDate(),
            rating: 6.7
        ),
        Media(
            id: 4011,
            type: .movie,
            backdropUrl: MovieDBUtils.getImageURL(file: "/yRKyJJYIzfeiVDHBe4LXguPQCvD.jpg", size: .original),
            imageUrl: MovieDBUtils.getImageURL(file: "/nnl6OWkyPpuMm595hmAxNW3rZFn.jpg", size: .small),
            name: "Beetlejuice",
            date: "1988-03-30".toDate(),
            rating: 7.381
        ),
        Media(
            id: 718821,
            type: .movie,
            backdropUrl: MovieDBUtils.getImageURL(file: "/7aPrv2HFssWcOtpig5G3HEVk3uS.jpg", size: .original),
            imageUrl: MovieDBUtils.getImageURL(file: "/pjnD08FlMAIXsfOLKQbvmO0f0MD.jpg", size: .small),
            name: "Twisters",
            date: "2024-07-10".toDate(),
            rating: 6.984
        ),
        Media(
            id: 1115396,
            type: .movie,
            backdropUrl: MovieDBUtils.getImageURL(file: "/x2thJwMJ6oGlhn7UC4vSwHltEw0.jpg", size: .original),
            imageUrl: MovieDBUtils.getImageURL(file: "/xVbEJzdMxIQqpuLgla0hU8qr9mt.jpg", size: .small),
            name: "Hunting Games",
            date: "2023-05-12".toDate(),
            rating: 4.2
        ),
        Media(
            id: 5492,
            type: .movie,
            backdropUrl: MovieDBUtils.getImageURL(file: "/bxwKC4qAbceMgHU1xCCTBK1eYdn.jpg", size: .original),
            imageUrl: MovieDBUtils.getImageURL(file: "/eEkAY5veAnwxUOOlpF62KawkFO9.jpg", size: .small),
            name: "Gunner",
            date: "2024-08-16".toDate(),
            rating: 5.4
        ),
        Media(
            id: 1079091,
            type: .movie,
            backdropUrl: MovieDBUtils.getImageURL(file: "/9BQqngPfwpeAfK7c2H3cwIFWIVR.jpg", size: .original),
            imageUrl: MovieDBUtils.getImageURL(file: "/4TzwDWpLmb9bWJjlN3iBUdvgarw.jpg", size: .small),
            name: "It Ends with Us",
            date: "2024-08-07".toDate(),
            rating: 6.734
        ),
        Media(
            id: 704239,
            type: .movie,
            backdropUrl: MovieDBUtils.getImageURL(file: "/4ft6TR9wA6bra0RLL6G7JFDQ5t1.jpg", size: .original),
            imageUrl: MovieDBUtils.getImageURL(file: "/d9CTnTHip1RbVi2OQbA2LJJQAGI.jpg", size: .small),
            name: "The Union",
            date: "2024-08-15".toDate(),
            rating: 6.258
        ),
        Media(
            id: 945961,
            type: .movie,
            backdropUrl: MovieDBUtils.getImageURL(file: "/9SSEUrSqhljBMzRe4aBTh17rUaC.jpg", size: .original),
            imageUrl: MovieDBUtils.getImageURL(file: "/b33nnKl1GSFbao4l3fZDDqsMx0F.jpg", size: .small),
            name: "Alien: Romulus",
            date: "2024-08-13".toDate(),
            rating: 7.11
        ),
        Media(
            id: 1160018,
            type: .movie,
            backdropUrl: MovieDBUtils.getImageURL(file: "/okVLmXL5y18dfN2R4ufMZEGaeCd.jpg", size: .original),
            imageUrl: MovieDBUtils.getImageURL(file: "/m2zXTuNPkywdYLyWlVyJZW2QOJH.jpg", size: .small),
            name: "Kill",
            date: "2024-07-03".toDate(),
            rating: 6.79
        ),
        Media(
            id: 1032823,
            type: .movie,
            backdropUrl: MovieDBUtils.getImageURL(file: "/p5kpFS0P3lIwzwzHBOULQovNWyj.jpg", size: .original),
            imageUrl: MovieDBUtils.getImageURL(file: "/jwoaKYVqPgYemFpaANL941EF94R.jpg", size: .small),
            name: "Trap",
            date: "2024-07-31".toDate(),
            rating: 6.5
        ),
        Media(
            id: 930600,
            type: .movie,
            backdropUrl: MovieDBUtils.getImageURL(file: "/qkEnklEGDFy4TRVhuHFn2DI2BP6.jpg", size: .original),
            imageUrl: MovieDBUtils.getImageURL(file: "/og1FteMFRInoQnlZeWqEn8XpXHh.jpg", size: .small),
            name: "The Deliverance",
            date: "2024-08-16".toDate(),
            rating: 6.316
        ),
        Media(
            id: 831815,
            type: .movie,
            backdropUrl: MovieDBUtils.getImageURL(file: "/hdFIdXwS8FSN2wIsuotjW1mshI0.jpg", size: .original),
            imageUrl: MovieDBUtils.getImageURL(file: "/30YnfZdMNIV7noWLdvmcJS0cbnQ.jpg", size: .small),
            name: "Saving Bikini Bottom: The Sandy Cheeks Movie",
            date: "2024-08-01".toDate(),
            rating: 6.411
        )
    ]
    
    // MARK: - Single TV Show Preview
    /// Datos reales de "The Grand Tour" extraídos del JSON.
    static let previewTV = Media(
        id: 67557,
        type: .tv,
        backdropUrl: MovieDBUtils.getImageURL(file: "/AvH03Lj5lMYxmlPc7prNQLWw6JY.jpg", size: .original),
        imageUrl: MovieDBUtils.getImageURL(file: "/3Pcqu6QliBWJ8vsOVClVLddPnZw.jpg", size: .small),
        name: "The Grand Tour",
        date: "2016-11-17".toDate(),
        rating: 8.0
    )
    
    // MARK: - TV Show List Preview
    /// Lista estática de 20 series de TV reales.
    static let previewTVList: [Media] = [
        Media(
            id: 67557,
            type: .tv,
            backdropUrl: MovieDBUtils.getImageURL(file: "/AvH03Lj5lMYxmlPc7prNQLWw6JY.jpg", size: .original),
            imageUrl: MovieDBUtils.getImageURL(file: "/3Pcqu6QliBWJ8vsOVClVLddPnZw.jpg", size: .small),
            name: "The Grand Tour",
            date: "2016-11-17".toDate(),
            rating: 8.0
        ),
        Media(
            id: 111800,
            type: .tv,
            backdropUrl: MovieDBUtils.getImageURL(file: "/x5VGLsI5Hgc1UgbQUCYIS6SIfYf.jpg", size: .original),
            imageUrl: MovieDBUtils.getImageURL(file: "/euYz4adiSHH0GE3YnTeh3uLfBvL.jpg", size: .small),
            name: "The Old Man",
            date: "2022-06-16".toDate(),
            rating: 7.2
        ),
        Media(
            id: 84773,
            type: .tv,
            backdropUrl: MovieDBUtils.getImageURL(file: "/NNC08YmJFFlLi1prBkK8quk3dp.jpg", size: .original),
            imageUrl: MovieDBUtils.getImageURL(file: "/mYLOqiStMxDK3fYZFirgrMt8z5d.jpg", size: .small),
            name: "The Lord of the Rings: The Rings of Power",
            date: "2022-09-01".toDate(),
            rating: 7.3
        ),
        Media(
            id: 223785,
            type: .tv,
            backdropUrl: MovieDBUtils.getImageURL(file: "/qcTXvYBxQriORMJwTD8NsUxXRcu.jpg", size: .original),
            imageUrl: MovieDBUtils.getImageURL(file: "/vZXSWqFklMIncnGCZVuyul9yNgF.jpg", size: .small),
            name: "Billionaire Island",
            date: "2024-09-12".toDate(),
            rating: 7.8
        ),
        Media(
            id: 82596,
            type: .tv,
            backdropUrl: MovieDBUtils.getImageURL(file: "/2p1qKfuUqvB1slMwNTjGYdWKS3K.jpg", size: .original),
            imageUrl: MovieDBUtils.getImageURL(file: "/qYGIf2QAhSIa5Xbf72QvLtte2e8.jpg", size: .small),
            name: "Emily in Paris",
            date: "2020-10-02".toDate(),
            rating: 7.7
        ),
        Media(
            id: 258582,
            type: .tv,
            backdropUrl: MovieDBUtils.getImageURL(file: "/jQIS8t8Zb58cj7gUBGvxhUl6QMG.jpg", size: .original),
            imageUrl: MovieDBUtils.getImageURL(file: "/kvCg1ljavJlBpdgsHNy383mtx8G.jpg", size: .small),
            name: "How to Die Alone",
            date: "2024-09-13".toDate(),
            rating: 7.3
        ),
        Media(
            id: 124003,
            type: .tv,
            backdropUrl: MovieDBUtils.getImageURL(file: "/qgTHKXeje3iInDXFaIBsIHpJQzu.jpg", size: .original),
            imageUrl: MovieDBUtils.getImageURL(file: "/xXa1CrLtlGha1Do6iIA7P5RaWLd.jpg", size: .small),
            name: "Perfect World",
            date: "2021-04-23".toDate(),
            rating: 8.5
        ),
        Media(
            id: 37854,
            type: .tv,
            backdropUrl: MovieDBUtils.getImageURL(file: "/2rmK7mnchw9Xr3XdiTFSxTTLXqv.jpg", size: .original),
            imageUrl: MovieDBUtils.getImageURL(file: "/cMD9Ygz11zjJzAovURpO75Qg7rT.jpg", size: .small),
            name: "One Piece",
            date: "1999-10-20".toDate(),
            rating: 8.7
        ),
        Media(
            id: 220564,
            type: .tv,
            backdropUrl: MovieDBUtils.getImageURL(file: "/3buRSGVnutw8x4Lww0t70k5dG6R.jpg", size: .original),
            imageUrl: MovieDBUtils.getImageURL(file: "/weyR73iYr1lWg17Q2r4sc7aEr2p.jpg", size: .small),
            name: "The Perfect Couple",
            date: "2024-09-05".toDate(),
            rating: 7.221
        ),
        Media(
            id: 253760,
            type: .tv,
            backdropUrl: MovieDBUtils.getImageURL(file: "/d9rVKhKKBDNykNFQZHZFl6yhenU.jpg", size: .original),
            imageUrl: MovieDBUtils.getImageURL(file: "/wsv9z5OFjCLsRG4lJkxb1hCRSnc.jpg", size: .small),
            name: "LEGO Star Wars: Rebuild the Galaxy",
            date: "2024-09-13".toDate(),
            rating: 5.5
        ),
        Media(
            id: 157219,
            type: .tv,
            backdropUrl: MovieDBUtils.getImageURL(file: "/n5MXQXuj5RnpZcxvDtO4sgzcKaY.jpg", size: .original),
            imageUrl: MovieDBUtils.getImageURL(file: "/esrggEWrlpjncn6y4tyHBJ0syLn.jpg", size: .small),
            name: "Midnight at the Pera Palace",
            date: "2022-03-03".toDate(),
            rating: 7.535
        ),
        Media(
            id: 239005,
            type: .tv,
            backdropUrl: MovieDBUtils.getImageURL(file: "/vas44Kp1BPca4ou2cBb4orAQ53F.jpg", size: .original),
            imageUrl: MovieDBUtils.getImageURL(file: "/nYDvkvutYQNKj2lhQTavGzgUE6L.jpg", size: .small),
            name: "Seoul Busters",
            date: "2024-09-11".toDate(),
            rating: 10.0
        ),
        Media(
            id: 261649,
            type: .tv,
            backdropUrl: MovieDBUtils.getImageURL(file: "/n7blHmJ9JjTv1DF8LRE5U4ywFS0.jpg", size: .original),
            imageUrl: MovieDBUtils.getImageURL(file: "/mMs6mEHPPtrTQ4mjc6hBHl6bApJ.jpg", size: .small),
            name: "Into the Fire: The Lost Daughter",
            date: "2024-09-12".toDate(),
            rating: 8.25
        ),
        Media(
            id: 95480,
            type: .tv,
            backdropUrl: MovieDBUtils.getImageURL(file: "/qhXdYysiamRu6moMGMZPQ4oVLvd.jpg", size: .original),
            imageUrl: MovieDBUtils.getImageURL(file: "/dnpatlJrEPiDSn5fzgzvxtiSnMo.jpg", size: .small),
            name: "Slow Horses",
            date: "2022-04-01".toDate(),
            rating: 7.869
        ),
        Media(
            id: 225282,
            type: .tv,
            backdropUrl: MovieDBUtils.getImageURL(file: "/iDyPeNsk3mugtRNY6zXYJyGpTsZ.jpg", size: .original),
            imageUrl: MovieDBUtils.getImageURL(file: "/6YzDtyY1lFDPHul33rl2sfn3pNf.jpg", size: .small),
            name: "En Fin",
            date: "2024-09-13".toDate(),
            rating: 5.667
        ),
        Media(
            id: 102621,
            type: .tv,
            backdropUrl: MovieDBUtils.getImageURL(file: "/oyKYPA1UXwwgrjmnM30sh33IRG5.jpg", size: .original),
            imageUrl: MovieDBUtils.getImageURL(file: "/dDBTUSl3tRsOeKC1jZugBSFHy9I.jpg", size: .small),
            name: "KAOS",
            date: "2024-08-29".toDate(),
            rating: 7.395
        ),
        Media(
            id: 224732,
            type: .tv,
            backdropUrl: MovieDBUtils.getImageURL(file: "/6glKAtqnxKwTI0OM2RAgLbbs0JS.jpg", size: .original),
            imageUrl: MovieDBUtils.getImageURL(file: "/4bsMbaKFDRfdYeCdNEYxRRlrZvL.jpg", size: .small),
            name: "Queen Woo",
            date: "2024-08-29".toDate(),
            rating: 8.1
        ),
        Media(
            id: 1399,
            type: .tv,
            backdropUrl: MovieDBUtils.getImageURL(file: "/zZqpAXxVSBtxV9qPBcscfXBcL2w.jpg", size: .original),
            imageUrl: MovieDBUtils.getImageURL(file: "/1XS1oqL89opfnbLl8WnZY1O1uJx.jpg", size: .small),
            name: "Game of Thrones",
            date: "2011-04-17".toDate(),
            rating: 8.455
        ),
        Media(
            id: 82684,
            type: .tv,
            backdropUrl: MovieDBUtils.getImageURL(file: "/xzjZDyqUobuJtkBljhgLH4Fdnye.jpg", size: .original),
            imageUrl: MovieDBUtils.getImageURL(file: "/jQb1ztdko9qc4aCdnMXShcIHXRG.jpg", size: .small),
            name: "That Time I Got Reincarnated as a Slime",
            date: "2018-10-02".toDate(),
            rating: 8.488
        ),
        Media(
            id: 194764,
            type: .tv,
            backdropUrl: MovieDBUtils.getImageURL(file: "/2ZPzpCmb0oE4o59GdEl5lrsi9lk.jpg", size: .original),
            imageUrl: MovieDBUtils.getImageURL(file: "/7hE6LffWtMccJjXxc20Xnh1JbRG.jpg", size: .small),
            name: "The Penguin",
            date: "2024-09-19".toDate(),
            rating: 10.0
        )
    ]
    
    // MARK: - Single Person Preview
    /// Datos reales de "Gary Oldman" (incluyendo backdrop de "The Dark Knight").
    static let previewPerson = Media(
        id: 64,
        type: .person,
        // Usamos el backdrop de su trabajo más conocido para que la UI no quede vacía
        backdropUrl: MovieDBUtils.getImageURL(file: "/nMKdUUepR0i5zn0y1T4CsSB5chy.jpg", size: .original),
        imageUrl: MovieDBUtils.getImageURL(file: "/2v9FVVBUrrkW2m3QOcYkuhq9A6o.jpg", size: .small),
        name: "Gary Oldman",
        date: nil, // People lists often don't show dates unless it's birthday detail
        rating: 187.171
    )
    
    // MARK: - People List Preview
    /// Lista estática de 20 personas populares.
    static let previewPersonList: [Media] = [
        Media(
            id: 64,
            type: .person,
            backdropUrl: MovieDBUtils.getImageURL(file: "/nMKdUUepR0i5zn0y1T4CsSB5chy.jpg", size: .original), // The Dark Knight
            imageUrl: MovieDBUtils.getImageURL(file: "/2v9FVVBUrrkW2m3QOcYkuhq9A6o.jpg", size: .small),
            name: "Gary Oldman",
            date: nil,
            rating: 187.171
        ),
        Media(
            id: 1152083,
            type: .person,
            backdropUrl: MovieDBUtils.getImageURL(file: "/oAcV4179Kdpvb2xk9TtS8Ewrp8q.jpg", size: .original), // Work It
            imageUrl: MovieDBUtils.getImageURL(file: "/o0anvGEg34MzoNh6hbJHthB3paF.jpg", size: .small),
            name: "Sabrina Carpenter",
            date: nil,
            rating: 161.071
        ),
        Media(
            id: 1763709,
            type: .person,
            backdropUrl: MovieDBUtils.getImageURL(file: "/32yqxyLlWcO81UCx51Jfq9aeJdA.jpg", size: .original), // Old
            imageUrl: MovieDBUtils.getImageURL(file: "/hNwZWdT2KxKj1YLbipvtUhNjfAp.jpg", size: .small),
            name: "Aaron Pierre",
            date: nil,
            rating: 140.691
        ),
        Media(
            id: 115440,
            type: .person,
            backdropUrl: MovieDBUtils.getImageURL(file: "/9KnIzPCv9XpWA0MqmwiKBZvV1Sj.jpg", size: .original), // Euphoria
            imageUrl: MovieDBUtils.getImageURL(file: "/qYiaSl0Eb7G3VaxOg8PxExCFwon.jpg", size: .small),
            name: "Sydney Sweeney",
            date: nil,
            rating: 137.863
        ),
        Media(
            id: 974169,
            type: .person,
            backdropUrl: MovieDBUtils.getImageURL(file: "/iHSwvRVsRyxpX7FE7GbviaDvgGZ.jpg", size: .original), // Wednesday
            imageUrl: MovieDBUtils.getImageURL(file: "/mNLx63JbIAHyfb3YNeVvGP9jfcv.jpg", size: .small),
            name: "Jenna Ortega",
            date: nil,
            rating: 122.705
        ),
        Media(
            id: 1245,
            type: .person,
            backdropUrl: MovieDBUtils.getImageURL(file: "/ozVwXlfxqNsariipatGwa5px3Pm.jpg", size: .original), // Lucy
            imageUrl: MovieDBUtils.getImageURL(file: "/6NsMbJXRlDZuDzatN2akFdGuTvx.jpg", size: .small),
            name: "Scarlett Johansson",
            date: nil,
            rating: 120.956
        ),
        Media(
            id: 976,
            type: .person,
            backdropUrl: MovieDBUtils.getImageURL(file: "/iP1cjN3ZGs1yJXROKaUj9hi1yF2.jpg", size: .original), // The Meg
            imageUrl: MovieDBUtils.getImageURL(file: "/whNwkEQYWLFJA8ij0WyOOAD5xhQ.jpg", size: .small),
            name: "Jason Statham",
            date: nil,
            rating: 117.168
        ),
        Media(
            id: 11701,
            type: .person,
            backdropUrl: MovieDBUtils.getImageURL(file: "/xjotE7aFdZ0D8aGriYjFOtDayct.jpg", size: .original), // Maleficent
            imageUrl: MovieDBUtils.getImageURL(file: "/k3W1XXddDOH2zibPkNotIh5amHo.jpg", size: .small),
            name: "Angelina Jolie",
            date: nil,
            rating: 103.499
        ),
        Media(
            id: 125025,
            type: .person,
            backdropUrl: MovieDBUtils.getImageURL(file: "/aqrDUkuzksLhOD8pbyBXLO0dz5t.jpg", size: .original), // The Kissing Booth
            imageUrl: MovieDBUtils.getImageURL(file: "/b0diEOPPAxOOInWOP9koaqvqUvi.jpg", size: .small),
            name: "Joey King",
            date: nil,
            rating: 101.787
        ),
        Media(
            id: 15152,
            type: .person,
            backdropUrl: MovieDBUtils.getImageURL(file: "/wXfAvsPZqBDJ8U78F2IAzsUxtNh.jpg", size: .original), // The Lion King
            imageUrl: MovieDBUtils.getImageURL(file: "/sgc8yxYr8ecNn1TXjWXWx3wmUYA.jpg", size: .small),
            name: "James Earl Jones",
            date: nil,
            rating: 101.101
        ),
        Media(
            id: 3371804,
            type: .person,
            backdropUrl: MovieDBUtils.getImageURL(file: "/zGkUjZNz7yhbPcCgVtrO24GvpLJ.jpg", size: .original), // Scorpio Nights 3
            imageUrl: MovieDBUtils.getImageURL(file: "/zdFbplqeZbzgCJEJfnj1pPqVVH2.jpg", size: .small),
            name: "Christine Bermas",
            date: nil,
            rating: 116.704
        ),
        Media(
            id: 1124416,
            type: .person,
            backdropUrl: MovieDBUtils.getImageURL(file: "/8gkSk2t9KFa1MWFxSYtyeq7hoM2.jpg", size: .original), // Naduvula Konjam Pakkatha Kaanom
            imageUrl: MovieDBUtils.getImageURL(file: "/gITvxeXz0Y7RC6fya3jUrRNr3A8.jpg", size: .small),
            name: "C. Prem Kumar",
            date: nil,
            rating: 107.683
        ),
        Media(
            id: 224513,
            type: .person,
            backdropUrl: MovieDBUtils.getImageURL(file: "/ilRyazdMJwN05exqhwK4tMKBYZs.jpg", size: .original), // Blade Runner 2049
            imageUrl: MovieDBUtils.getImageURL(file: "/3vxvsmYLTf4jnr163SUlBIw51ee.jpg", size: .small),
            name: "Ana de Armas",
            date: nil,
            rating: 105.894
        ),
        Media(
            id: 73968,
            type: .person,
            backdropUrl: MovieDBUtils.getImageURL(file: "/4oYBCR2CWtKpfkOKCzpmlE5EdxY.jpg", size: .original), // Man of Steel
            imageUrl: MovieDBUtils.getImageURL(file: "/iWdKjMry5Pt7vmxU7bmOQsIUyHa.jpg", size: .small),
            name: "Henry Cavill",
            date: nil,
            rating: 105.471
        ),
        Media(
            id: 6384,
            type: .person,
            backdropUrl: MovieDBUtils.getImageURL(file: "/ncEsesgOJDNrTUED89hYbA117wo.jpg", size: .original), // The Matrix
            imageUrl: MovieDBUtils.getImageURL(file: "/4D0PpNI0kmP58hgrwGC3wCjxhnm.jpg", size: .small),
            name: "Keanu Reeves",
            date: nil,
            rating: 103.857
        ),
        Media(
            id: 1907997,
            type: .person,
            backdropUrl: nil, // This entry had no backdrop in known_for[0] in JSON
            imageUrl: MovieDBUtils.getImageURL(file: "/bHHn3krbHyxQIWb4JbHkPlV6Uu1.jpg", size: .small),
            name: "Min Do-yoon",
            date: nil,
            rating: 99.929
        ),
        Media(
            id: 26723,
            type: .person,
            backdropUrl: MovieDBUtils.getImageURL(file: "/lHe8iwM4Cdm6RSEiara4PN8ZcBd.jpg", size: .original), // Vikings
            imageUrl: MovieDBUtils.getImageURL(file: "/vQSqH3ybDWZHZIqX4NZKhOCXAhQ.jpg", size: .small),
            name: "Katheryn Winnick",
            date: nil,
            rating: 97.695
        ),
        Media(
            id: 933271,
            type: .person,
            backdropUrl: MovieDBUtils.getImageURL(file: "/zSJT1sKGRKcmP4I9b8dIOuepw6I.jpg", size: .original), // Robin Hood
            imageUrl: MovieDBUtils.getImageURL(file: "/Dj3osDr5zSP7uMtBBbbUeIgRMu.jpg", size: .small),
            name: "Eve Hewson",
            date: nil,
            rating: 95.719
        ),
        Media(
            id: 94854,
            type: .person,
            backdropUrl: MovieDBUtils.getImageURL(file: "/5P6hWD4zxAMntRuRnB4MmPLijNw.jpg", size: .original), // The Blind Side
            imageUrl: MovieDBUtils.getImageURL(file: "/b823hpQ5FzQeom8Sj6DJ81ezVWQ.jpg", size: .small),
            name: "Tom Nowicki",
            date: nil,
            rating: 94.845
        ),
        Media(
            id: 2049994,
            type: .person,
            backdropUrl: MovieDBUtils.getImageURL(file: "/wQlJJJ50gKphCci0SmoetUXmJN4.jpg", size: .original), // Hidden Love
            imageUrl: MovieDBUtils.getImageURL(file: "/xNxgskyAM9mtrusbXL7j03Askpa.jpg", size: .small),
            name: "Zhao Lusi",
            date: nil,
            rating: 89.597
        )
    ]
    
    
    // MARK: - Mixed List Preview
    /// Lista estática de resultados mixtos (Movies, TV, People) simulando una búsqueda de "Brad".
    static let previewAllList: [Media] = [
        Media(
            id: 1163787,
            type: .movie,
            backdropUrl: nil, // JSON tiene backdrop_path: null
            imageUrl: MovieDBUtils.getImageURL(file: "/fUdSdxEMPY7zLOKaPo0pEGwW8DN.jpg", size: .small),
            name: "Brad",
            date: "2023-08-11".toDate(),
            rating: 0.0
        ),
        Media(
            id: 287,
            type: .person,
            backdropUrl: MovieDBUtils.getImageURL(file: "/1Jpkm9qZcsT0mSyVXgs4VlGjPNI.jpg", size: .original), // Inglourious Basterds
            imageUrl: MovieDBUtils.getImageURL(file: "/ajNaPmXVVMJFg9GWmu6MJzTaXdV.jpg", size: .small),
            name: "Brad Pitt",
            date: nil,
            rating: 51.751
        ),
        Media(
            id: 1460120,
            type: .person,
            backdropUrl: MovieDBUtils.getImageURL(file: "/sVkjgKq8cwKm95LCyfrLldLbQIG.jpg", size: .original), // King Arthur
            imageUrl: MovieDBUtils.getImageURL(file: "/8IBIRaUl4QyttlieUfKVBR2Ia5J.jpg", size: .small),
            name: "Millie Brady",
            date: nil,
            rating: 22.721
        ),
        Media(
            id: 3640594,
            type: .person,
            backdropUrl: MovieDBUtils.getImageURL(file: "/embPe2zFOVzVDMm66tGD31r4NQA.jpg", size: .original),
            imageUrl: nil, // JSON profile_path: null
            name: "Brad",
            date: nil,
            rating: 0.001
        ),
        Media(
            id: 4443325,
            type: .person,
            backdropUrl: nil,
            imageUrl: nil,
            name: "Brad",
            date: nil,
            rating: 0.001
        ),
        Media(
            id: 94330,
            type: .person,
            backdropUrl: MovieDBUtils.getImageURL(file: "/pXqA3aUxrsdUbthRqBhnNUi0RVe.jpg", size: .original), // American Ninja 3
            imageUrl: MovieDBUtils.getImageURL(file: "/uu275GxZrHfqcaBJx6DeSuHEYWy.jpg", size: .small),
            name: "David Bradley",
            date: nil,
            rating: 15.986
        ),
        Media(
            id: 160930,
            type: .person,
            backdropUrl: MovieDBUtils.getImageURL(file: "/tS4KTDwmE2sk7YOzoytW3Gb0kDf.jpg", size: .original), // Zombies of the Stratosphere
            imageUrl: MovieDBUtils.getImageURL(file: "/mRn7rr4JK2AuLeQrau6vVmjYJcN.jpg", size: .small),
            name: "Lane Bradford",
            date: nil,
            rating: 5.884
        ),
        Media(
            id: 11367,
            type: .person,
            backdropUrl: MovieDBUtils.getImageURL(file: "/o8dPH0ZSIyyViP6rjRX1djwCUwI.jpg", size: .original), // Get Out
            imageUrl: MovieDBUtils.getImageURL(file: "/oeDv2qZWTxELLaNtOIoeG72leNY.jpg", size: .small),
            name: "Bradley Whitford",
            date: nil,
            rating: 6.356
        ),
        Media(
            id: 1370,
            type: .person,
            backdropUrl: MovieDBUtils.getImageURL(file: "/6Oa3zTiluBz2W8D2ou1MY16dUiF.jpg", size: .original), // One Flew Over the Cuckoo's Nest
            imageUrl: MovieDBUtils.getImageURL(file: "/z2LYR7Ickql7g5hnWJSIAWMPD4o.jpg", size: .small),
            name: "Brad Dourif",
            date: nil,
            rating: 18.064
        ),
        Media(
            id: 7087,
            type: .person,
            backdropUrl: MovieDBUtils.getImageURL(file: "/se5Hxz7PArQZOG3Nx2bpfOhLhtV.jpg", size: .original), // The Incredibles
            imageUrl: MovieDBUtils.getImageURL(file: "/z73rItPBDoRUowY5kuWDMlue3DB.jpg", size: .small),
            name: "Brad Bird",
            date: nil,
            rating: 10.631
        ),
        Media(
            id: 2126,
            type: .tv,
            backdropUrl: MovieDBUtils.getImageURL(file: "/pEjsb26MKpLzvGcg9OtLptXpNyH.jpg", size: .original),
            imageUrl: MovieDBUtils.getImageURL(file: "/fnTz1POoEhO31KyEDyj1K4HsGVx.jpg", size: .small),
            name: "The Brady Bunch",
            date: "1969-09-26".toDate(),
            rating: 6.7
        ),
        Media(
            id: 51329,
            type: .person,
            backdropUrl: MovieDBUtils.getImageURL(file: "/sV49hOlUky6AhVYl4K0d3rergTA.jpg", size: .original), // The Hangover
            imageUrl: MovieDBUtils.getImageURL(file: "/DPnessSsWqVXRbKm93PtMjB4Us.jpg", size: .small),
            name: "Bradley Cooper",
            date: nil,
            rating: 34.339
        ),
        Media(
            id: 19227,
            type: .person,
            backdropUrl: MovieDBUtils.getImageURL(file: "/2vq5GTJOahE03mNYZGxIynlHcWr.jpg", size: .original), // Ford v Ferrari
            imageUrl: MovieDBUtils.getImageURL(file: "/8c9M5MPYA5hFXHqmmoJSO0BBGTD.jpg", size: .small),
            name: "Brad Beyer",
            date: nil,
            rating: 6.922
        ),
        Media(
            id: 3069,
            type: .person,
            backdropUrl: MovieDBUtils.getImageURL(file: "/6g0MFaqYpUX9W7CXEq44ZcoxNz.jpg", size: .original), // Filth
            imageUrl: MovieDBUtils.getImageURL(file: "/rkzXK3dRUd9n22RZHC22E130ieq.jpg", size: .small),
            name: "Therese Bradley",
            date: nil,
            rating: 5.179
        ),
        Media(
            id: 226370,
            type: .person,
            backdropUrl: MovieDBUtils.getImageURL(file: "/zIxWFekMJkxUFp52xAWSP0mhB8k.jpg", size: .original), // Sharpay's Fabulous Adventure
            imageUrl: MovieDBUtils.getImageURL(file: "/n62ZTaV7xFfOICwcSa6l2hC1K8v.jpg", size: .small),
            name: "Bradley Steven Perry",
            date: nil,
            rating: 5.902
        ),
        Media(
            id: 17772,
            type: .person,
            backdropUrl: MovieDBUtils.getImageURL(file: "/m0miV65ZZIp13TNHJSRUF6vmCos.jpg", size: .original), // Romeo + Juliet
            imageUrl: MovieDBUtils.getImageURL(file: "/aT3eZzGDMKrwlYgHtwBH4KHKa64.jpg", size: .small),
            name: "Jesse Bradford",
            date: nil,
            rating: 9.032
        ),
        Media(
            id: 41945,
            type: .person,
            backdropUrl: nil,
            imageUrl: nil,
            name: "Brad Bartram",
            date: nil,
            rating: 3.175
        ),
        Media(
            id: 4802083,
            type: .person,
            backdropUrl: MovieDBUtils.getImageURL(file: "/4wrAcpHQvMlTdXwn2TvdVtsmNtz.jpg", size: .original), // a.k.a. F**K
            imageUrl: nil,
            name: "Brad",
            date: nil,
            rating: 0.001
        ),
        Media(
            id: 18,
            type: .person,
            backdropUrl: MovieDBUtils.getImageURL(file: "/eCynaAOgYYiw5yN5lBwz3IxqvaW.jpg", size: .original), // Finding Nemo
            imageUrl: MovieDBUtils.getImageURL(file: "/813ffbpoaoaJRdoe1yrbivboWKp.jpg", size: .small),
            name: "Brad Garrett",
            date: nil,
            rating: 14.608
        ),
        Media(
            id: 1010135,
            type: .person,
            backdropUrl: MovieDBUtils.getImageURL(file: "/zZqpAXxVSBtxV9qPBcscfXBcL2w.jpg", size: .original), // Game of Thrones
            imageUrl: MovieDBUtils.getImageURL(file: "/eLcisM9qqCLWnf0iImHuSn08FOi.jpg", size: .small),
            name: "John Bradley",
            date: nil,
            rating: 11.968
        )
    ]
}
#endif
