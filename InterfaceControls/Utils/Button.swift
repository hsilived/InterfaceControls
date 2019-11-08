 //
 //  Button.swift
 //  Plasticity
 //
 //  Created by DeviL on 2018-12-31.
 //  Copyright © 2018 Orange Think Box. All rights reserved.
 //
 
 import SpriteKit

 protocol ButtonDelegate: class {
    func buttonPressed(_: Button)
    func buttonReleased(_: Button)
 }
 
class Button: SKSpriteNode {
    
    weak var delegate: ButtonDelegate!
    
    let kButtonFontColor = SKColor(white: 0.2, alpha: 1.0)
    
    //var turbo = false
    private var isPressed: Bool?
    private var isToggle = false
    private var priorToggle = false
    private var image: SKSpriteNode?
    private var toggleImage: String?
    private var buttonImage: String?
    private var sendTouchEventToParent = false
    
    private var upTexture: SKTexture?
    private var downTexture: SKTexture?
    private var disabledTexture: SKTexture?
    private var selectedTexture: SKTexture?
//    var initialPos = CGPoint.zero
    private var initialXScale: CGFloat = 1
    private var initialYScale: CGFloat = 1
    private var buttonSound = SKAction.playSoundFileNamed("tap.caf", waitForCompletion: false)
    
    private weak var buttonParent: SKNode?
    
    //var stringAction: (() -> ())? = nil
    //var actionType: ButtonActionType?
//    var objectTouchUpInside: String?
    private var hasText = false

    //MARK: custom properties

    private var hasIcon: Bool {
        
        return !(image == nil)
    }
    
    var isHighlighted: Bool = false {
        
        didSet {
            
            //run(SKAction.scaleX(to: isHighlighted ? xScale * 1.1 : initialXScale, y: isHighlighted ? yScale * 1.1 : initialYScale, duration: 0.15), withKey: "highlight")
            
            if isHighlighted {
                
                guard isEnabled else { return }
                
                if downTexture != nil {
                    texture = downTexture
                }
                
                if (self.action(forKey: "jiggle") != nil) {
                    run(SKAction(named: "jiggleUpDown")!, withKey: "jiggle")
                }
            }
            else {
                
                if downTexture != nil {
                    self.texture = upTexture
                }
                
                run(.wait(forDuration: 0.15)) {
                    self.removeAllActions()
                }
            }
        }
    }
    
    var isDepressed: Bool = false {
        
        didSet {
            
            guard (isEnabled || !isEnabled && !isDepressed), selectedTexture == nil, downTexture == nil, !isToggle else { return }
            
            run(SKAction.scaleX(to: isDepressed ? initialXScale * 0.8 : initialXScale * 1.0, y: isDepressed ? initialYScale * 0.8 : initialYScale * 1.0, duration: 0.15))
        }
    }
    
    var isToggled: Bool = false {
        
        didSet {
            
            guard isToggle, toggleImage != nil, buttonImage != nil else { return }
            
            self.texture = SKTexture(imageNamed: isToggled ? toggleImage! : buttonImage!)
        }
    }
    
    var isSelected: Bool = false {
        
        didSet {
            
            guard isEnabled else { return }
            
            if selectedTexture != nil {
                self.texture = isSelected ? selectedTexture : upTexture
            }
            else {
                
                if downTexture != nil {// && !self.isHighlighted {
                    
                    self.texture = isSelected ? downTexture : upTexture
                    if hasText {
                        titleTextLabel.position = CGPoint(x: self.titleTextLabel.position.x, y: isSelected ? -2 : 0)
                    }
                    if hasIcon {
                        image!.position.y = isSelected ? 6 : 10
                    }
                }
            }
        }
    }
    
    var isEnabled: Bool = true {
        
        didSet {

            //if button has pending actions wait .5 seconds then reset it
//            let wait = SKAction.wait(forDuration: self.hasActions() ? 0.5 : 0)
//            var returnColor: SKAction!
            color = .black
            
            if isEnabled {
                colorBlendFactor = 0
                
//                returnColor = SKAction.colorize(withColorBlendFactor: 0.0, duration: 0.5)
//                alpha = 1.0
            }
            else {
                colorBlendFactor = 0.3
//                returnColor = SKAction.colorize(withColorBlendFactor: 0.3, duration: 0.2)
            }
            
//            let seq = SKAction.sequence([wait, returnColor])
//            run(seq)
            
            if disabledTexture != nil {
                texture = isEnabled ? upTexture : disabledTexture
            }
        }
    }
    
    //MARK: button attributes
    
    var icon: String? {
        
        didSet {
            
            image = SKSpriteNode(imageNamed: icon!)
            image!.position = CGPoint(x: 0, y: 10)
            image?.zPosition = 10
            addChild(image!)
        }
    }
    
//    func setButtonAction(target: AnyObject, event: ButtonActionType, function: Optional<() -> ()>, parent: SKNode!) {
//
//        //let newAction: nil //Selector = Selector(action().description)
//        stringAction = function
//        actionType = event
//        buttonParent = parent
//    }
    
    lazy var titleTextLabel: SKLabelNode = {
        
        let titleLabel = SKLabelNode(fontNamed: kGameFont)
        titleLabel.fontColor = self.kButtonFontColor
        titleLabel.fontSize = 68
        titleLabel.horizontalAlignmentMode = .center
        titleLabel.verticalAlignmentMode = SKLabelVerticalAlignmentMode.center
        //titleLabel.setScale(self.upTexture!.size().width / self.size.width)
        titleLabel.position = CGPoint.zero
        titleLabel.zPosition = 10
        self.addChild(titleLabel)
        
        self.hasText = true
        
        return titleLabel
    }()
    
    func createButtonText(buttonText: String, fontSize: CGFloat = 80, fontColor: SKColor? = nil, alignment: SKLabelHorizontalAlignmentMode = .center) {
        
        titleTextLabel.text = buttonText
        titleTextLabel.fontSize = fontSize
        titleTextLabel.fontColor = fontColor == nil ? kButtonFontColor : fontColor
        titleTextLabel.horizontalAlignmentMode = alignment
    }

    //MARK: initilizers
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        
        isUserInteractionEnabled = true
    }
    
    func quickSetUpWith(imageBaseName: String? = "", inset: CGFloat = 0, size: CGSize = CGSize.zero) {
        
        upTexture = self.texture
        
        if size != CGSize.zero {
            self.size = size
            super.size = size
        }
        
        //       e: upTexture, color: UIColor.white, size: localSize)
        //
        //        self.size = localSize
        //        self.upTexture = upTexture
        //        self.downTexture = downTexture
        //
        //        if inset.x > 0 {
        //            centerRect = CGRect(x: inset.x / (upTexture?.size().width)!, y: inset.y / (upTexture?.size().height)!, width: ((upTexture?.size().width)! - inset.x * 2) / (upTexture?.size().width)!, height: ((upTexture?.size().height)! - inset.y * 2) / (upTexture?.size().height)!)
        //            xScale = size.width / (upTexture?.size().width)!
        //            yScale = size.height / (upTexture?.size().height)!
        //
        //            initialXScale = xScale
        //            initialYScale = yScale
        //        }
        
        
        if imageBaseName != nil && imageBaseName != "" {
            
            let downTextureName = imageBaseName! + "_down.png"
            if SKTextureAtlas(named: "Sprites").textureNames.contains(downTextureName) {
                self.downTexture = SKTexture(imageNamed: downTextureName)
            }
            else {
                downTexture = nil
            }
            
            //print("upTexture?.size() \(upTexture?.size())")
            if inset > 0 && size != CGSize.zero {
                centerRect = CGRect(x: inset / (upTexture?.size().width)!, y: inset / (upTexture?.size().height)!, width: ((upTexture?.size().width)! - inset * 2) / (upTexture?.size().width)!, height: ((upTexture?.size().height)! - inset * 2) / (upTexture?.size().height)!)
                xScale = size.width / (upTexture?.size().width)!
                yScale = size.height / (upTexture?.size().height)!
                
                //print("xScale \(xScale)")
                //print("yScale \(yScale)")
            }
        }
        
        //self.actionType = actionType
        buttonParent = self.parent!
        initialXScale = xScale
        initialYScale = yScale
    }
    
    func quickSetUpTextureAndAction(imageTexture: SKTexture, action: (() -> ())?) {
        
        upTexture = imageTexture
        downTexture = nil
        //actionType = .touchUpInside
        buttonParent = parent
        initialXScale = xScale
        initialYScale = yScale
    }
    
    func quickSetUpWith(image: String? = "", icon: String? = "", delegate: ButtonDelegate? = nil) {
        
        if image != nil && image != "" {
            upTexture = SKTexture(imageNamed: image! + "_up")
        }
        else {
            upTexture = self.texture
        }
        downTexture = nil
        if delegate == nil {
            self.delegate = parent as? ButtonDelegate
        }
        else {
            self.delegate = delegate
        }
        buttonParent = parent
        initialXScale = xScale
        initialYScale = yScale
        
        if !(icon?.isEmpty)! {
            self.icon = icon
        }
    }
    
    func quickSetUpAndDownTextures(image: String, delegate: ButtonDelegate? = nil) {
        
        upTexture = SKTexture(imageNamed: image + "_up")
        downTexture = SKTexture(imageNamed: image + "_down")
        
        if delegate == nil {
            self.delegate = parent as? ButtonDelegate
        }
        else {
            self.delegate = delegate
        }
        
        buttonParent = parent
        initialXScale = xScale
        initialYScale = yScale
    }
    
    func quickSetUpToggle(image: String, delegate: ButtonDelegate? = nil) {
        
        buttonImage = image + "_off"
        toggleImage = image + "_on"
        
        if delegate == nil {
            self.delegate = parent as? ButtonDelegate
        }
        else {
            self.delegate = delegate
        }
        
        isToggle = true
        buttonParent = parent
        initialXScale = xScale
        initialYScale = yScale
    }

    convenience init(upImage: String? = nil, downImage: String? = nil, inset: CGPoint = CGPoint.zero, size: CGSize = CGSize.zero) {
        
        let upTexture: SKTexture? = (upImage != nil) ? SKTexture(imageNamed: upImage!) : nil
        let downTexture: SKTexture? = (downImage != nil) ? SKTexture(imageNamed: downImage!) : nil
        
        self.init(upTexture: upTexture, downTexture: downTexture, inset: inset, size: size)
    }
    
    //up and down textures, x inset , y inset and size
    init(upTexture: SKTexture?, downTexture: SKTexture? = nil, inset: CGPoint = CGPoint.zero, size: CGSize = CGSize.zero) {
        
        var localSize = size
        
        if localSize == CGSize.zero {
            localSize = (upTexture?.size())!
        }
        
        super.init(texture: upTexture, color: UIColor.white, size: localSize)
        
        self.size = localSize
        self.upTexture = upTexture
        self.downTexture = downTexture
        
        if inset.x > 0 {
            centerRect = CGRect(x: inset.x / (upTexture?.size().width)!, y: inset.y / (upTexture?.size().height)!, width: ((upTexture?.size().width)! - inset.x * 2) / (upTexture?.size().width)!, height: ((upTexture?.size().height)! - inset.y * 2) / (upTexture?.size().height)!)
            xScale = size.width / (upTexture?.size().width)!
            yScale = size.height / (upTexture?.size().height)!
            
            initialXScale = xScale
            initialYScale = yScale
        }
        
        self.isHighlighted = false
        self.isSelected = false
        self.isEnabled = true
        isUserInteractionEnabled = true
    }
    
    //MARK: Touches Methods
    
    //This method only occurs, if the touch was inside this node. Furthermore if the Button is enabled, the texture should change to "selectedTexture".
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent!)  {
        
        guard isEnabled, !isSelected else {  return }
        
        priorToggle = isToggled
        isToggled = !isToggled
        isSelected = true
        isDepressed = true
        isPressed = false
        
        if sendTouchEventToParent {
            super.touchesBegan(touches, with: event)
        }

        self.run(buttonSound)
        
        self.delegate?.buttonPressed(self)
        //buttonParent?.run(SKAction.run(stringAction!))
    }
    
    //If the Button is enabled: This method looks, where the touch was moved to. If the touch moves outside of the button, the isSelected property is restored to NO and the texture changes to "normalTexture".
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent!)  {
        
        guard isEnabled else { return }
        
        if let touch = touches.first as UITouch? {
            
            let touchLocation = touch.location(in: parent!)
            
            if !frame.contains(touchLocation) {
                isDepressed = false
                isSelected = false
                isPressed = false
                isToggled = priorToggle
                
                self.removeAllActions()
            }
        }
        
        if sendTouchEventToParent {
            super.touchesMoved(touches, with: event)
        }
    }
    
    //If the Button is enabled AND the touch ended in the buttons frame, the selector of the target is run.
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent!) {
        
        guard isEnabled else { return }
        
        if let touch = touches.first as UITouch? {
            
            let touchLocation = touch.location(in: parent!)
            
            if frame.contains(touchLocation) {
                
                buttonParent = nil
                //self.removeAllActions()
                self.delegate?.buttonReleased(self)
            }
        }
        
        isPressed = false
        isDepressed = false
        //isHighlighted = false
        
        if !isToggle {
            isSelected = false
        }
        
        if (self.action(forKey: "highlight") != nil) {
            print("is highlighted")
        }
        
        if (self.action(forKey: "jiggle") != nil) {
            print("is jiggling")
        }
        //print("\n\nself has actions \(self.hasActions())\n\n")
        if sendTouchEventToParent {
            buttonParent!.touchesEnded(touches, with: event)
        }
    }
}
