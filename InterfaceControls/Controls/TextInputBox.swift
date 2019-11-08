//
//  TextInputBox.swift
//  TextInputBox
//
//  Created by Orange Think Box
//  Copyright (c) 2017 Orange Think Box. All rights reserved.
//
import SpriteKit

protocol TextInputBoxDelegate: NSObject {
    
    func textInputNodeDidStartEditing(textInputNode: TextInputBox)
    
    //TODO: I think that these 2 should have been optional
    func textInputNodeDidChange(textInputNode: TextInputBox)
    func textInputNodeShouldClear(textInputNode: TextInputBox) -> Bool
    
    //this doesn't get called from here. i'm just ensuring that the parent has this func
    func resetEditingOnAllTextBoxes()
}

class TextInputBox: SKSpriteNode {
    
    weak var delegate: TextInputBoxDelegate!
    var maxTextLength: Int = 0
    var blank: Bool = false
    var wasEditing: Bool = false
    var characters: [String] = [String]()
    var keyboard: Keyboard!
    var keyboardYPos: CGFloat?
    
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
            
            let tempString = initialText
            
            //characters = Array<Any>(tempString.characters) as! [String]
            characters = tempString.map { String($0) }
            
//            for i in 0..<initialText.characters.count - 1 {
//
//                //get the individual letter from the string and add it to the characters array
//                let index = initialText.startIndex.advancedBy(i)
//                characters.append("\(initialText[index])")
//            }
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
                toggleCaratSymbolHidden(hidden: false)
                
                if !keyboard.presented {
                    
//                    if keyboardYPos != nil {
//                        keyboard.present(yPos: keyboardYPos)
//                    }
//                    else {
                        keyboard.present()
//                    }
                }
                keyboard.delegate = self
                wasEditing = true
            }
            else {
                
                //hide carat
                toggleCaratSymbolHidden(hidden: true)
                
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
    
    private lazy var textLabel: SKLabelNode = {
        
        let tempLabel = SKLabelNode(fontNamed: kTextBoxFont)
        tempLabel.fontColor = kDefaultTextColor
        tempLabel.fontSize = kTextBoxFontSize
        tempLabel.position = CGPoint(x: (0 - self.size.width / 2) + 20, y: 0)
        tempLabel.zPosition = 10
        tempLabel.verticalAlignmentMode = .center
        tempLabel.horizontalAlignmentMode = .left
        self.addChild(tempLabel)
        
        return tempLabel
    }()
    
    private lazy var caratSymbol: SKSpriteNode = {
        
        let carat = SKSpriteNode(imageNamed: "carat")
        carat.size = CGSize(width: carat.texture!.size().width * kTextBoxFontSize / carat.texture!.size().height, height: kTextBoxFontSize)
        carat.zPosition = 10
        self.addChild(carat)
        carat.run(self.pulseForever())
        
        return carat
    }()
    
    //MARK:- Initializers
    
    init(keyboard: Keyboard, size: CGSize) {
        
        super.init(texture: nil ,color: .clear, size:size)
        
        self.keyboard = keyboard

        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        
        setup()
    }
    
    func setup() {
        
        isUserInteractionEnabled = true
        blank = true
        
        let textBox = SKSpriteNode(imageNamed: "textbox")
        let insetX: CGFloat = 9
        let insetY: CGFloat = 9
        let boxWidth = textBox.size.width
        let boxHeight = textBox.size.height
        textBox.centerRect = CGRect(x: insetX / boxWidth, y: insetY / boxHeight, width: (boxWidth - insetX * 2) / boxWidth, height: (boxHeight - insetY * 2) / boxHeight)
        textBox.xScale = size.width / boxWidth
        textBox.yScale = size.height / boxHeight
        addChild(textBox)
    }
    
    func toggleCaratSymbolHidden(hidden: Bool) {
        
        caratSymbol.isHidden = hidden
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
            pos = textLabel.position.x + textLabel.frame.size.width + 5
        }
        caratSymbol.position = CGPoint(x: pos, y: caratSymbol.position.y)
    }
    
    func decrementCaratPosition(amount: Int) {
        caratSymbol.position = CGPoint(x: caratSymbol.position.x - CGFloat(amount), y: caratSymbol.position.y)
    }
    
    func incrementCaratPosition(amount: Int) {
        caratSymbol.position = CGPoint(x: caratSymbol.position.x + CGFloat(amount), y: caratSymbol.position.y)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        print("touch ended")
        super.touchesEnded(touches, with: event)
        
        //we send this out to the delgate to control editing so that we can swicth off editing on everything else
        delegate.textInputNodeDidStartEditing(textInputNode: self)
    }
}

//MARK: - KeyboardDelegate

extension TextInputBox: KeyboardDelegate {

    func keyboard(keyboard: Keyboard, didSelectCharacter character: String) {
        
        if text.count == maxTextLength { return }
        
        blank = false
        removeDefault()
        text = "\(text)\(character)"
        if (character == " ") {
            incrementCaratPosition(amount: Int(kAmountToMoveCaratForSpace))
        }
        else {
            setCaratPosition()
        }
        characters.append(character)
    }
    
    func keyboardDidHitDeleteKey(keyboard: Keyboard) {
        
        if blank { return }
        
        //if ([delegate textInputNodeShouldClear:self]) {
        let string: String = text
   
        if string.count < 1 { return }
        

        let endIndex = string.index(string.endIndex, offsetBy: -1)
//        let newString = string.substring(to: endIndex)
        let newString = String(string[..<endIndex])
        
        if (newString == "") {
            blank = true
        }
        
        text = newString
        characters.removeLast()
        
        if (characters.last == " ") {
            decrementCaratPosition(amount: Int(kAmountToMoveCaratForSpace))
        }
        else {
            setCaratPosition()
        }
    }
    
    func keyboardDidHitEnterKey() {
        
        editing = false
        
        if (text == "") || (text == " ") {
            resetDefault()
        }
        
        toggleCaratSymbolHidden(hidden: true)
        
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
        toggleCaratSymbolHidden(hidden: true)
    }
    
    func pulseForever() -> SKAction {
        
        let fadeOut = SKAction.fadeOut(withDuration: 0.2)
        let fadeIn = SKAction.fadeIn(withDuration: 0.2)
        let pulse = SKAction.sequence([fadeOut, fadeIn])
        let pulseForever = SKAction.repeatForever(pulse)
        return pulseForever
    }
}
