//
//  SKEmitterNode+Extensions.swift
//  SafeBuster
//
//  Created by DeviL on 2017-10-15.
//  Copyright © 2017 Orange Think Box. All rights reserved.
//

import Foundation
import SpriteKit

extension SKEmitterNode {
    
    class func nodeFileWith(_ fileName: NSString) -> SKEmitterNode {
        
        let baseFileName: String = fileName.deletingPathExtension
        var fileExtension: String = fileName.pathExtension
        
        if fileExtension.isEmpty {
            fileExtension = "sks"
        }
       
        let emitterPath : String = Bundle.main.path(forResource: baseFileName, ofType:fileExtension)!
        
        let node: SKEmitterNode = NSKeyedUnarchiver.unarchiveObject(withFile: emitterPath) as! SKEmitterNode
        
        return node
    }
    
    public class func skt_emitterNamed(_ name: String) -> SKEmitterNode {
        print("name \(name)" )
        return NSKeyedUnarchiver.unarchiveObject(withFile: Bundle.main.path(forResource: name, ofType: "sks")!) as! SKEmitterNode
    }
    
    func dieInDuration(_ duration: TimeInterval) {
        
        let firstWait: SKAction = SKAction.wait(forDuration: duration)
        let weakSelf: SKEmitterNode = self
        let stop: SKAction = SKAction.run({
            weakSelf.particleBirthRate = 0
        })
        let secondWait: SKAction = SKAction.wait(forDuration: TimeInterval(self.particleLifetime))
        let remove: SKAction = SKAction.removeFromParent()
        let die: SKAction = SKAction.sequence([firstWait, stop, secondWait, remove])
        self.run(die)
    }
}
