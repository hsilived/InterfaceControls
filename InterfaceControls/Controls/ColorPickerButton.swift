//
//  ColorPickerButton.swift
//  InterfaceControls
//
//  Created by ron myschuk on 2016-01-29.
//  Copyright © 2019 Orange Think Box. All rights reserved.
//

import Foundation
import SpriteKit

protocol ColorPickerButtonDelegate: NSObjectProtocol {
    func colorPickerButtonPushed(_ colorPickerButton: ColorPickerButton)
}

class ColorPickerButton : SKSpriteNode {

    weak var delegate: ColorPickerButtonDelegate?
    
    var background: SKSpriteNode!
    var buttonSound: SKAction!
        
    //MARK: - Lazy Instantiations
    
    private lazy var colorPickerIcon: SKSpriteNode = {
    
        let symbol = SKSpriteNode(imageNamed: "color_picker")
        var width = symbol.texture!.size().width * self.size.width / self.background.texture!.size().width
        var height = symbol.texture!.size().height * self.size.height / self.background.texture!.size().height
        symbol.size = CGSize(width: width, height: height)
        symbol.zPosition = 1
        self.addChild(symbol)

        return symbol
    }()
    
    init(size: CGSize) {
        
        super.init(texture: nil, color: .clear, size: size)

        name = "colorPickerButton"
        self.size = size
        zPosition = 10
        
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setup()
    }
    
    func setup() {
        
        isUserInteractionEnabled = true
        isPaused = false
        
        let keyWidth: CGFloat = size.width
        let insetX: CGFloat = 9
        let insetY: CGFloat = 9
        
        background = SKSpriteNode(imageNamed: "direction_button")
        background.centerRect = CGRect(x: insetX / background.size.width, y: insetY / background.size.height, width: (background.size.width - insetX * 2) / background.size.width, height: (background.size.height - insetY * 2) / background.size.height)
        background.xScale = keyWidth / background.size.width
        background.yScale = size.height / background.size.height
        addChild(background)
        
        colorPickerIcon.xScale = 1.0
        
        buttonSound = SKAction.playSoundFileNamed("tap.caf", waitForCompletion: false)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        run(SKAction.scale(to: 0.8, duration: 0.1))
        run(buttonSound)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        run(SKAction.sequence([SKAction.scale(to: 1.1, duration: 0.1), SKAction.scale(to: 1.0, duration: 0.1), SKAction.run({() -> Void in
            self.parent?.run(SKAction.run( { self.delegate!.colorPickerButtonPushed(self) } ))
        })]))
    }
}
