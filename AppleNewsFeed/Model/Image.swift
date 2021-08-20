//
//  Movie.swift
//  TableList
//
//  Created by kristine.lazdovska on 03/08/2021.
//

import Foundation

struct Image {
    
    let poster: String
    var results: [Result]? = []
    
    static func createImage () -> [Image]{
        var images: [Image] = []
        
        let posters = DataManager.shared.poster
        
        for index in 0..<posters.count {
            let poster = Image (poster: posters[index])
            images.append(poster)
        }
        return images
    }
}
