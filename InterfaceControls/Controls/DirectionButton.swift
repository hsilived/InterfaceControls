//
//  DirectionButton.swift
//  InterfaceControls
//
//  Created by ron myschuk on 2016-01-29.
//  Copyright © 2016 Orange Think Box. All rights reserved.
//

import Foundation
import SpriteKit

enum ButtonDirection : Int {
    case Back
    case Forward
}

protocol DirectionButtonDelegate: NSObjectProtocol {
    func directionButtonPushed(_ directionButton: DirectionButton)
}

class DirectionButton : SKSpriteNode {

    weak var delegate: DirectionButtonDelegate?
    
    var direction: ButtonDirection = .Back
    var background: SKSpriteNode = SKSpriteNode()
    var buttonSound: SKAction!
    
    var target: AnyObject!
    var buttonAction: ((DirectionButton) -> ())!
    
    //MARK: - Lazy Instantiations
    
    private lazy var directionSymbol: SKSpriteNode = {
    
        let symbol = SKSpriteNode(imageNamed: "direction_symbol")
        var width: CGFloat = symbol.texture!.size().width * self.size.width / self.background.texture!.size().width
        var height: CGFloat = symbol.texture!.size().height * self.size.height / self.background.texture!.size().height
        symbol.size = CGSize(width: width, height: height)
        symbol.zPosition = 1
        self.addChild(symbol)

        return symbol
    }()
    
    init(direction: ButtonDirection, size: CGSize, target: AnyObject) {
        
        super.init(texture: nil, color: .clear, size: size)
        
        let keyWidth: CGFloat = size.width
        let insetX: CGFloat = 9
        let insetY: CGFloat = 9
        
        name = (direction == .Back) ? "back" : "forward"
        self.target = target
        self.direction = direction
        self.size = CGSize(width: keyWidth, height: size.height)
        zPosition = 10
        isUserInteractionEnabled = true
        
        background = SKSpriteNode(imageNamed: "direction_button")
        background.centerRect = CGRect(x: insetX / background.size.width, y: insetY / background.size.height, width: (background.size.width - insetX * 2) / background.size.width, height: (background.size.height - insetY * 2) / background.size.height)
        background.xScale = keyWidth / background.size.width
        background.yScale = size.height / background.size.height
        addChild(background)
        
        if direction == .Forward {
            directionSymbol.xScale = 1.0
        }
        else {
            directionSymbol.xScale = -1.0
        }
        
        buttonSound = SKAction.playSoundFileNamed("tap.caf", waitForCompletion: false)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        run(SKAction.scale(to: 0.8, duration: 0.1))
        run(buttonSound)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        run(SKAction.sequence([SKAction.scale(to: 1.1, duration: 0.1), SKAction.scale(to: 1.0, duration: 0.1), SKAction.run({() -> Void in
            //self.parent!.performSelector(onMainThread: self.action, with: self, waitUntilDone: true)
            self.parent?.run(SKAction.run( { self.delegate!.directionButtonPushed(self) } ))
        })]))
    }
}
