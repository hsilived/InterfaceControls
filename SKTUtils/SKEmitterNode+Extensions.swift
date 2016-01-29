//
//  SKEmitterNode+Extensions.swift
//  Drive To Survive
//
//  Created by DeviL on 2015-10-15.
//  Copyright © 2015 Orange Think Box. All rights reserved.
//

import Foundation
import SpriteKit

extension SKEmitterNode {
    
    class func nodeFileWith(fileName: NSString) -> SKEmitterNode {
        
        let baseFileName: String = fileName.stringByDeletingPathExtension
        var fileExtension: String = fileName.pathExtension
        
        if fileExtension.isEmpty {
            fileExtension = "sks"
        }
       
        let emitterPath : String = NSBundle.mainBundle().pathForResource(baseFileName, ofType:fileExtension)!
        
        let node: SKEmitterNode = NSKeyedUnarchiver.unarchiveObjectWithFile(emitterPath) as! SKEmitterNode
        
        return node
    }
    
    public class func skt_emitterNamed(name: String) -> SKEmitterNode {
        
        return NSKeyedUnarchiver.unarchiveObjectWithFile(NSBundle.mainBundle().pathForResource(name, ofType: "sks")!) as! SKEmitterNode
    }
    
    func dieInDuration(duration: NSTimeInterval) {
        
        let firstWait: SKAction = SKAction.waitForDuration(duration)
        let weakSelf: SKEmitterNode = self
        let stop: SKAction = SKAction.runBlock({
            weakSelf.particleBirthRate = 0
        })
        let secondWait: SKAction = SKAction.waitForDuration(NSTimeInterval(self.particleLifetime))
        let remove: SKAction = SKAction.removeFromParent()
        let die: SKAction = SKAction.sequence([firstWait, stop, secondWait, remove])
        self.runAction(die)
    }
}