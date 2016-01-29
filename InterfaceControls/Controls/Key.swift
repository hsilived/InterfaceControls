//
//  Key.swift
//  InterfaceControls
//
//  Created by ron myschuk on 2016-01-16.
//  Copyright © 2016 Orange Think Box. All rights reserved.
//

import Foundation
import SpriteKit

class Key: SKSpriteNode {

    var target: AnyObject!
    var action: Selector!
    
    init(character: String, size: CGSize, target: AnyObject, action: Selector) {

        super.init(texture: nil ,color: .clearColor(), size:size)
        
        self.name = character
        var keyWidth: CGFloat = size.width
        
        if (character == kKeyEnter) {
            keyWidth = size.width * 2 + kSpaceBetweenKeys - size.width / 2
        }
        else if (character == kKeySpace) {
            keyWidth = size.width * 6 + kSpaceBetweenKeys * 5
        }
        
        self.size = CGSizeMake(keyWidth, self.size.height)
        let key: SKSpriteNode = SKSpriteNode(imageNamed: "key")
        let insetX: CGFloat = 9
        let insetY: CGFloat = 9
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
            self.characterSymbol.texture = SKTexture(imageNamed: "delete_icon")
            self.characterSymbol.size = self.characterSymbol.texture!.size()
            self.characterLabel.text = ""
        }
        
        if (character == "close") {
            self.characterSymbol.texture = SKTexture(imageNamed: "close_keyboard_icon")
            self.characterSymbol.size = self.characterSymbol.texture!.size()
            self.characterLabel.text = ""
        }
        
        self.setTarget(target, action: action)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setTarget(target: AnyObject, action: Selector) {
        
        self.target = target
        self.action = action
    }
    
    private lazy var characterLabel: SKLabelNode = {
        
        let charLabel = SKLabelNode(fontNamed: kMiscFont)
        charLabel.fontColor = kTextColor
        charLabel.fontSize = 30
        charLabel.verticalAlignmentMode = .Center
        charLabel.horizontalAlignmentMode = .Center
        self.addChild(charLabel)
        
        return charLabel
    }()
    
    private lazy var characterSymbol: SKSpriteNode = {
        
        let charSymbol = SKSpriteNode(color: .redColor(), size: CGSizeMake(20, 20))
        self.addChild(charSymbol)
        
        return charSymbol
    }()
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        self.runAction(SKAction.scaleTo(1.1, duration: 0.1))
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        self.runAction(SKAction.sequence([SKAction.scaleTo(0.8, duration: 0.1), SKAction.scaleTo(1.0, duration: 0.1), SKAction.runBlock({() -> Void in
            self.target.performSelectorOnMainThread(self.action, withObject: self, waitUntilDone: true)
        })]))
    }
}
