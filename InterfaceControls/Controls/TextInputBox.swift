//
//  TextInputBox.m
//  TextInputBox
//
//  Created by Ron Myschuk
//  Copyright (c) 2015 Orange Think Box. All rights reserved.
//
import SpriteKit

protocol TextInputBoxDelegate {
    
    func textInputNodeDidStartEditing(textInputNode: TextInputBox)
    func textInputNodeDidChange(textInputNode: TextInputBox)
    func textInputNodeShouldClear(textInputNode: TextInputBox) -> Bool
}

class TextInputBox: SKSpriteNode, KeyboardDelegate {
    
    var delegate: TextInputBoxDelegate!
    var maxTextLength: Int = 0
    var blank: Bool = false
    var wasEditing: Bool = false
    var characters: [String] = [String]()
    var keyboard: Keyboard!
    
    //MARK: - Custom Properties
    
    var defaultText: String = "" {
        
        didSet {
            text = defaultText
        }
    }
    
    var text: String = "" {
        
        didSet {
            textLabel.text = text
        }
    }
    
    var initialText: String = "" {
        
        didSet {
            
            for i in 0..<initialText.characters.count - 1 {
                
                //get the individual letter from the string and add it to the characters array
                let index = initialText.startIndex.advancedBy(i)
                characters.append("\(initialText[index])")
            }
            blank = false
            textLabel.fontColor = kTextColor
            text = initialText
        }
    }
    
    var editing: Bool = false {
        
        didSet {
            
            if editing {
                
                removeDefault()
                //display carat
                toggleCaratSymbolHidden(false)
                
                if !keyboard.presented {
                    keyboard.present()
                }
                keyboard.delegate = self
                wasEditing = true
            }
            else {
                
                //hide carat
                toggleCaratSymbolHidden(true)
                
                if (text == "") {
                    resetDefault()
                }
                
                if wasEditing {
                    wasEditing = false
                    keyboard.delegate = nil
                }
            }
        }
    }
    
    init(keyboard: Keyboard, size: CGSize) {
        
        super.init(texture: nil ,color: .clearColor(), size:size)
        
        self.keyboard = keyboard
        //keyboard.delegate = self;
        //keyboard = [Keyboard keyboardNodeWithScene:self];
        //keyboard.dataSource = self;
        userInteractionEnabled = true
        anchorPoint = CGPointMake(0.5, 0.5)
        //position = CGPointMake(-size.width / 2, 0);
        blank = true
        let textBox: SKSpriteNode = SKSpriteNode(imageNamed: "textbox")
        let insetX: CGFloat = 9
        let insetY: CGFloat = 9
        textBox.centerRect = CGRectMake(insetX / textBox.size.width, insetY / textBox.size.height, (textBox.size.width - insetX * 2) / textBox.size.width, (textBox.size.height - insetY * 2) / textBox.size.height)
        textBox.xScale = size.width / textBox.size.width
        textBox.yScale = size.height / textBox.size.height
        addChild(textBox)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var textLabel: SKLabelNode = {
        
        let tempLabel = SKLabelNode(fontNamed: kTextBoxFont)
        tempLabel.fontColor = kDefaultTextColor
        tempLabel.fontSize = kTextboxFontSize
        tempLabel.position = CGPointMake(-self.size.width / 2 + 10, 0)
        tempLabel.verticalAlignmentMode = .Center
        tempLabel.horizontalAlignmentMode = .Left
        self.addChild(tempLabel)
        
        return tempLabel
    }()
    
    private lazy var caratSymbol: SKSpriteNode = {
    
        let carat = SKSpriteNode(imageNamed: "carat")
        carat.size = CGSizeMake(carat.texture!.size().width * kTextboxFontSize / carat.texture!.size().height, kTextboxFontSize)
        self.addChild(carat)
        carat.runAction(self.pulseForever())
        
        return carat
    }()
    
    func toggleCaratSymbolHidden(hidden: Bool) {
        
        caratSymbol.hidden = hidden
        if !hidden {
            setCaratPosition()
        }
    }
    
    func setCaratPosition() {
        
        var pos: CGFloat
        
        if blank {
            pos = textLabel.position.x
        }
        else {
            pos = textLabel.position.x + textLabel.frame.size.width
        }
        caratSymbol.position = CGPointMake(pos, caratSymbol.position.y)
    }
    
    func decrementCaratPosition(amount: Int) {
        caratSymbol.position = CGPointMake(caratSymbol.position.x - CGFloat(amount), caratSymbol.position.y)
    }
    
    func incrementCaratPosition(amount: Int) {
        caratSymbol.position = CGPointMake(caratSymbol.position.x + CGFloat(amount), caratSymbol.position.y)
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        NSLog("touch ended")
        super.touchesEnded(touches, withEvent: event)
        delegate.textInputNodeDidStartEditing(self)
    }
    
    //MARK: - Keyboard Delegate
    
    func keyboard(keyboard: Keyboard, didSelectCharacter character: String) {
        
        if text.characters.count == maxTextLength { return }
        
        blank = false
        removeDefault()
        text = "\(text)\(character)"
        if (character == " ") {
            incrementCaratPosition(Int(kAmountToMoveCaratForSpace))
        }
        else {
            setCaratPosition()
        }
        characters.append(character)
    }
    
    func keyboardDidHitDeleteKey(keyboardNode: Keyboard) {
        
        if blank { return }
        
        //if ([delegate textInputNodeShouldClear:self]) {
        let string: String = text
        var newString: String = ""
        
        if string.characters.count < 1 { return }
        
        for i in 0..<string.characters.count - 1 {
            
            //get the individual letter from the string
            let index = string.startIndex.advancedBy(i)
            newString = "\(newString)\(string[index])"
        }
        
        if (newString == "") {
            blank = true
        }
        
        //        [self resetDefault];
        //    }
        //    else {
        text = newString
        characters.removeLast()
        
        if (characters.last == " ") {
            decrementCaratPosition(Int(kAmountToMoveCaratForSpace))
        }
        else {
            setCaratPosition()
        }
        // }
    }
    
    func keyboardDidHitEnterKey() {
        
        editing = false
        
        if (text == "") || (text == " ") {
            resetDefault()
        }
        
        keyboard.dismiss()
    }
    
    func removeDefault() {
        
        if blank {
            text = ""
            textLabel.fontColor = kTextColor
            setCaratPosition()
        }
    }
    
    func resetDefault() {
        
        blank = true
        text = defaultText
        textLabel.fontColor = kDefaultTextColor
        //hide carat
        toggleCaratSymbolHidden(true)
    }
    
    func pulseForever() -> SKAction {
        
        let fadeOut: SKAction = SKAction.fadeOutWithDuration(0.2)
        let fadeIn: SKAction = SKAction.fadeInWithDuration(0.2)
        let pulse: SKAction = SKAction.sequence([fadeOut, fadeIn])
        let pulseForever: SKAction = SKAction.repeatActionForever(pulse)
        return pulseForever
    }
}