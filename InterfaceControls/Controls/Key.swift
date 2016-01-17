//
//  Key.swift
//  InterfaceControls
//
//  Created by ron myschuk on 2016-01-16.
//  Copyright © 2016 Orange Think Box. All rights reserved.
//

import Foundation
import SpriteKit

class Key {
    
    
    convenience override init(character: String, size: CGSize, target: AnyObject, action: Selector) {
        
        if self(color: SKColor.clearColor(), size: size) {
            self.name = character
            var keyWidth: Float = size.width
            if (character == kKeyEnter) {
                keyWidth = size.width * 2 + kSpaceBetweenKeys - size.width / 2
            }
            else if (character == kKeySpace) {
                keyWidth = size.width * 6 + kSpaceBetweenKeys * 5
            }
            
            self.size = CGSizeMake(keyWidth, self.size.height)
            var key: SKSpriteNode = SKSpriteNode.spriteNodeWithImageNamed("key")
            var insetX: Int = 9
            var insetY: Int = 9
            key.centerRect = CGRectMake(insetX / key.size.width, insetY / key.size.height, (key.size.width - insetX * 2) / key.size.width, (key.size.height - insetY * 2) / key.size.height)
            key.xScale = keyWidth / key.size.width
            key.yScale = size.height / key.size.height
            self.addChild(key)
            self.userInteractionEnabled = true
            self.characterLabel.text = character
            
            if (character == "done") || (character == "space") {
                characterLabel.fontSize = 24.0
            }
            
            if (character == "delete") {
                self.characterSymbol.texture = SKTexture.textureWithImageNamed("delete_icon")
                self.characterSymbol.size = self.characterSymbol.texture.size
                self.characterLabel.text = ""
            }
            
            if (character == "close") {
                self.characterSymbol.texture = SKTexture.textureWithImageNamed("close_keyboard_icon")
                self.characterSymbol.size = self.characterSymbol.texture.size
                self.characterLabel.text = ""
            }
            
            self.setTarget(target, action: action)
        }
    }
    
    convenience init(character: String, size: CGSize, target: AnyObject, action: Selector) {
        
        return self(character: character, size: size, target: target, action: action)
    }
    
    func setTarget(target: AnyObject, action: Selector) {
        
        self.target = target
        self.action = action
    }
    
    func characterLabel() -> SKLabelNode {
        
        if !characterLabel {
            
            characterLabel = SKLabelNode(fontNamed: "Helvetica-Neue")
            characterLabel.fontSize = 30.0
            characterLabel.fontColor = SKColor(white: 0.2, alpha: 1.0)
            characterLabel.verticalAlignmentMode = .Center
            self.addChild(characterLabel)
        }
        return characterLabel
    }
    
    func characterSymbol() -> SKSpriteNode {
        
        if !characterSymbol {
            
            characterSymbol = SKSpriteNode.spriteNodeWithColor(SKColor.redColor(), size: CGSizeMake(20, 20))
            self.addChild(characterSymbol)
        }
        return characterSymbol
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        self.runAction(SKAction.scaleTo(1.1, duration: 0.1))
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        self.runAction(SKAction.sequence([SKAction.scaleTo(0.8, duration: 0.1), SKAction.scaleTo(1.0, duration: 0.1), SKAction.runBlock({() -> Void in
            self.target.performSelectorOnMainThread(self.action, withObject: self, waitUntilDone: true)
        })]))
    }
}
