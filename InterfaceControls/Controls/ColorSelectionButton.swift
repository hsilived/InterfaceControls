//
//  ColorSelectionButton.swift
//  ColorSelectionButton
//
//  Created by Ron Myschuk
//  Copyright (c) 2017 Orange Think Box. All rights reserved.
//
import SpriteKit

protocol ColorSelectionButtonDelegate: NSObjectProtocol {
    func unhighlightAllButtons(colorSelectionButton: ColorSelectionButton)
    func selectColor(_ colorSelectionButton: ColorSelectionButton)
}

class ColorSelectionButton: SKSpriteNode {
    
    weak var delegate: ColorSelectionButtonDelegate?
    
    private var buttonSound: SKAction!
    private var initialSize: CGFloat = 0
    private var highlight: SKSpriteNode!
    private var background: SKSpriteNode!
    
    //this is only used on the popup color selector right now
    var multiPos: MultiPosition?
    
    var colorString = ""

    var isHighlighted = false {
        
        didSet {
            
            if isHighlighted {
                highlight = SKSpriteNode(texture: SKTexture(imageNamed: "color_base"))
                highlight.run(.colorize(with: .red, colorBlendFactor: 1.0, duration: 0.1))
                highlight.size =  CGSize(width: initialSize * 1.2, height: initialSize * 1.2)
                highlight.name = "highlight"
                highlight.zPosition = -1
                self.addChild(highlight)
            }
            else {
                if let highlight = self.childNode(withName: "highlight") as? SKSpriteNode {
                    highlight.removeFromParent()
                }
            }
        }
    }
    
    // MARK: Initialization

    convenience init(color: String, size: CGSize) {
        
        self.init(color: SKColor(hexString: color)!, size: size)
    }
    
    init(color: SKColor, size: CGSize) {
        
        super.init(texture: nil, color: .clear, size: size)
        
        texture = SKTexture(imageNamed: "color_base")
        zPosition = 2
        isUserInteractionEnabled = true
        name = "color"
        self.color = color
        
        colorString = color.hexString
        initialSize = size.width

        self.run(SKAction.colorize(with: self.color, colorBlendFactor: 1.0, duration: 0.0))
        
        let colorHighlight = SKSpriteNode(imageNamed: "color_highlight")
        colorHighlight.size = self.size
        colorHighlight.zPosition = 1
        colorHighlight.alpha = 0.4
        self.addChild(colorHighlight)

        buttonSound = SKAction.playSoundFileNamed("tap.caf", waitForCompletion: false)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Touches Events

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent!)  {
        
        self.run(SKAction.scale(to: 0.8, duration: 0.1))
        
        run(buttonSound)
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent!) {
        
        self.delegate?.unhighlightAllButtons(colorSelectionButton: self)
        
        self.isHighlighted = true

        self.run(SKAction.sequence([SKAction.scale(to: 1.1, duration: 0.1), SKAction.scale(to: 1.0, duration: 0.1), SKAction.run( {
            self.delegate?.selectColor(self)
        })]))
    }
}
