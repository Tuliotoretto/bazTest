//
//  Show.swift
//  bazTest
//
//  Created by Julian Garcia  on 16/06/23.
//

import Foundation

public struct Show: Codable, Equatable {
    
    let id: Int
    let url: String
    let name: String
    let image: Image
    let summary: String
    let externals: Externals
    
    public static func == (lhs: Show, rhs: Show) -> Bool {
        lhs.id == rhs.id
    }
}

struct Image: Codable {
    let medium, original: String
}

enum ImageSize {
    case medium, original
}

struct Externals: Codable {
    let imdb: String?
}

extension Show {
    init(favShow: FavoriteShows) {
        self.id = Int(favShow.id)
        self.url = ""
        self.name = favShow.name ?? ""
        self.image = Image(medium: favShow.imageMedium ?? "", original: favShow.imageOriginal ?? "")
        self.summary = favShow.summary ?? ""
        self.externals = Externals(imdb: favShow.externals)
    }
}
