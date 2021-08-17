//
//  Item.swift
//  AppleNewsFeed
//
//  Created by kristine.lazdovska on 09/08/2021.
//

import UIKit
import Gloss

class Item: JSONDecodable {
    
    var description: String
    var name: String
    var path: String
    var thumbnail: UIImage?
    var id: String
    
    
    required init?(json: JSON) {
        self.description = "description" <~~ json ?? ""
        self.name = "name" <~~ json ?? ""
        self.path = "path" <~~ json ?? ""
        self.id = "id" <~~ json ?? ""
        
        DispatchQueue.main.async {
            self.thumbnail = self.laodImage()
        }
        
    }
    
    private func laodImage() -> UIImage? {
        var returnImage: UIImage?
        
        guard let path = URL(string: path) else {
            return returnImage
        }
        
        if let data = try? Data(contentsOf: path){
            if let image = UIImage(data: data){
                returnImage = image
            }
        }
        return returnImage
    }

}
