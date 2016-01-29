//
//  SKSpriteNode+Extensions.swift
//  Drive To Survive
//
//  Created by DeviL on 2015-10-13.
//  Copyright © 2015 Orange Think Box. All rights reserved.
//

import Foundation
import SpriteKit

extension SKSpriteNode {
    
    var width: CGFloat {
        
        get {
            
            return size.width
        }
        set {
            
            size.width = newValue
        }
    }
    
    var height: CGFloat {
        
        get {
            
            return size.height
        }
        set {
            
            size.height = newValue
        }
    }
}