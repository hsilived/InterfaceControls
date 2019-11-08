//
//  NumericButton.swift
//  InterfaceControls
//
//  Created by ron myschuk on 2016-01-29.
//  Copyright © 2016 Orange Think Box. All rights reserved.
//

import Foundation
import SpriteKit

enum NumericDirection : Int {
    case down
    case up
}

protocol NumericButtonDelegate: NSObjectProtocol {
    func numericButtonPushed(_ numericButton: NumericButton)
}

class NumericButton : SKSpriteNode {
    
    weak var delegate: NumericButtonDelegate?
    
    var numericDirection: NumericDirection = .down
    private var background: SKSpriteNode!
    private var numericDirectionSymbol: SKSpriteNode!
    private var buttonSound: SKAction!

    init(numericDirection: NumericDirection, size: CGSize) {
        
        super.init(texture: nil ,color: .clear, size: size)
        
        let keyWidth: CGFloat = size.width
        name = numericDirection == .down ? "down" : "up"
        self.numericDirection = numericDirection
        self.size = CGSize(width: keyWidth, height: size.height)
        isUserInteractionEnabled = true
        zPosition = 1
        
        background = SKSpriteNode(imageNamed: "direction_button")
        let insetX: CGFloat = 9
        let insetY: CGFloat = 9
        let boxWidth = background.size.width
        let boxHeight = background.size.height
        background.centerRect = CGRect(x: insetX / boxWidth, y: insetY / boxHeight, width: (boxWidth - insetX * 2) / boxWidth, height: (boxHeight - insetY * 2) / boxHeight)
        background.xScale = size.width / boxWidth
        background.yScale = size.height / boxHeight
        addChild(background)
        
        addSymbol(numericDirection: numericDirection)

        buttonSound = SKAction.playSoundFileNamed("tap.caf", waitForCompletion: false)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addSymbol(numericDirection: NumericDirection) {
        
        if numericDirection == .up {
            numericDirectionSymbol = SKSpriteNode(imageNamed: "up_symbol")
        }
        else {
            numericDirectionSymbol = SKSpriteNode(imageNamed: "down_symbol")
        }
        
        let width: CGFloat = numericDirectionSymbol.texture!.size().width * size.width / background.texture!.size().width
        let height: CGFloat = numericDirectionSymbol.texture!.size().height * size.height / background.texture!.size().height
        numericDirectionSymbol.size = CGSize(width: width, height: height)
        numericDirectionSymbol.zPosition = 10
        addChild(numericDirectionSymbol)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        run(buttonSound)
        run(SKAction.scale(to: 0.8, duration: 0.1))
        run(SKAction.sequence([SKAction.run({() -> Void in
            self.parent!.run(SKAction.run( { self.delegate!.numericButtonPushed(self) } ))
        }), SKAction.wait(forDuration: 0.75), SKAction.run({
            self.run(SKAction.repeatForever(SKAction.sequence([SKAction.wait(forDuration: 0.125), SKAction.run({
                self.delegate!.numericButtonPushed(self)
                self.run(self.buttonSound)
            })])))
        })]), withKey: "changeNumber")
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        removeAction(forKey: "changeNumber")
        run(SKAction.sequence([SKAction.scale(to: 1.1, duration: 0.1), SKAction.scale(to: 1.0, duration: 0.1), SKAction.run({
            self.removeAllActions()
        })]))
    }
}
