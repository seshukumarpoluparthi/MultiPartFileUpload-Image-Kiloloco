//
//  Media.swift
//  MultiPart
//
//  Created by apple on 9/2/18.
//  Copyright © 2018 apple. All rights reserved.
//

import Foundation
import UIKit
struct Media {
    let key : String
    let filename : String
    let data : Data
    let mimeType : String
    init?(withImage image : UIImage , forKey key : String) {
        self.key = key
        self.mimeType = "image/jpeg"
        self.filename = "photo\(arc4random()).jpeg"
        guard let data = UIImageJPEGRepresentation(image, 0.7) else { return nil }
        self.data = data
    }
}

