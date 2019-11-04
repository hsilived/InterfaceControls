//
//  Key.swift
//  InterfaceControls
//
//  Created by ron myschuk on 2016-01-16.
//  Copyright © 2016 Orange Think Box. All rights reserved.
//

import Foundation
import SpriteKit

protocol KeyButtonDelegate: NSObjectProtocol {
    func keyButtonPushed(_ keyButton: KeyButton)
}

class KeyButton: SKSpriteNode {

    weak var delegate: KeyButtonDelegate?
    
    private var target: SKNode?
    private var buttonAction: ((KeyButton) -> ())!
    private var buttonSound: SKAction!
    
    init(character: String, size: CGSize, target: SKNode) {

        super.init(texture: nil ,color: .clear, size:size)

        var keyWidth: CGFloat = size.width
        
        if (character == kKeyEnter) {
            keyWidth = size.width * 2 + kSpaceBetweenKeys - size.width / 2
        }
        else if (character == kKeySpace) {
            keyWidth = size.width * 6 + kSpaceBetweenKeys * 5
        }
        
        name = character
        isUserInteractionEnabled = true
        self.size = CGSize(width: keyWidth, height: size.height)
        zPosition = 1
        self.target = target

        let key: SKSpriteNode = SKSpriteNode(imageNamed: "key")
        let insetX: CGFloat = 18
        let insetY: CGFloat = 18
        let boxWidth = key.size.width
        let boxHeight = key.size.height
        key.centerRect = CGRect(x: insetX / boxWidth, y: insetY / boxHeight, width: (boxWidth - insetX * 2) / boxWidth, height: (boxHeight - insetY * 2) / boxHeight)
        key.xScale = keyWidth / boxWidth
        key.yScale = size.height / boxHeight
        key.zPosition = 2
        addChild(key)
        
        characterLabel.text = character
        
        if (character == "done") || (character == "space") {
            characterLabel.fontSize = 48.0
        }
        
        //TODO: should probably have a double version of these characters??
        if (character == "delete") {
            characterSymbol.texture = SKTexture(imageNamed: "delete_icon")
            characterSymbol.size = self.characterSymbol.texture!.size()
            characterSymbol.setScale(2.0)
            characterLabel.text = ""
        }
        
        if (character == "close") {
            characterSymbol.texture = SKTexture(imageNamed: "close_keyboard_icon")
            characterSymbol.size = self.characterSymbol.texture!.size()
            characterLabel.text = ""
        }
        
        buttonSound = SKAction.playSoundFileNamed("tap.caf", waitForCompletion: false)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var characterLabel: SKLabelNode = {
        
        let charLabel = SKLabelNode(fontNamed: kMiscFont)
        charLabel.fontColor = kTextColor
        charLabel.fontSize = 60
        charLabel.verticalAlignmentMode = .center
        charLabel.horizontalAlignmentMode = .center
        charLabel.zPosition = 10
        self.addChild(charLabel)
        
        return charLabel
    }()
    
    private lazy var characterSymbol: SKSpriteNode = {
        
        let charSymbol = SKSpriteNode(color: .red, size: CGSize(width: 40, height: 40))
        charSymbol.zPosition = 10
        self.addChild(charSymbol)
        
        return charSymbol
    }()
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        run(.scale(to: 1.1, duration: 0.1))
        run(buttonSound)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        run(.sequence([SKAction.scale(to: 0.8, duration: 0.1), .scale(to: 1.0, duration: 0.1), .run({
            //self.target.performSelector(self.action, withObject: self, waitUntilDone: true)
            self.parent?.run(SKAction.run({ self.delegate?.keyButtonPushed(self) }))
        })]))
    }
}
