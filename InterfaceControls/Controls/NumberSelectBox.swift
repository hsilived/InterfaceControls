//
//  NumberSelectBox.swift
//  InterfaceControls
//
//  Created by ron myschuk on 2016-01-29.
//  Copyright © 2016 Orange Think Box. All rights reserved.
//

import Foundation
import SpriteKit

protocol NumberSelectBoxDelegate: NSObject {
    func numberSelectBoxDidStartEditing(numberSelectBox: NumberSelectBox)
}

class NumberSelectBox: SKSpriteNode {
    
    weak var delegate: NumberSelectBoxDelegate!
    
    var maxTextLength: Int = 0
    var number: Int = 0

    //MARK: - Custom Properties
    
    var text: String = "" {
        
        didSet {
            textLabel.text = text
        }
    }
    
    var defaultText: String = "" {
        
        didSet {
            
            let alphaNums = CharacterSet.decimalDigits
            let inStringSet = CharacterSet(charactersIn: defaultText)
            
            if alphaNums.isSuperset(of: inStringSet as CharacterSet) {

                self.number = Int(defaultText)!
                self.text = defaultText
            }
            else {
                self.text = String(format: "%0*d", maxTextLength, number)
            }
        }
    }
    
    var initialText: String = "" {
    
        didSet {
            
            defaultText = initialText
        }
    }
    
    //MARK: - Lazy Instantiations
    
    private lazy var downButton: NumericButton = {
        
        let button = NumericButton(numericDirection: .down, size: CGSize(width: self.size.height, height: self.size.height))
        button.delegate = self
        button.position = CGPoint(x: self.size.width / 2 + button.size.width / 2, y: 0)
        self.addChild(button)
        
        return button
    }()
    
    private lazy var upButton: NumericButton = {
        
        let button = NumericButton(numericDirection: .up, size: CGSize(width: self.size.height, height: self.size.height))
        button.delegate = self
        button.position = CGPoint(x: self.downButton.position.x + button.size.width, y: 0)
        self.addChild(button)
        
        return button
    }()
    
    private lazy var textLabel: SKLabelNode = {
        
        let label = SKLabelNode(fontNamed: kTextBoxFont)
        label.fontColor = kTextColor
        label.fontSize = kTextBoxFontSize
        label.position = CGPoint(x: 0, y: 0)
        label.zPosition = 10
        label.verticalAlignmentMode = .center
        label.horizontalAlignmentMode = .center
        self.addChild(label)
        
        return label
    }()
    
    //MARK:- Initializers
    
    init(size: CGSize) {
 
        super.init(texture: nil ,color: .clear, size: size)
        
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        
        setup()
    }
    
    func setup() {
        
        isUserInteractionEnabled = true
        number = 0

        let insetX: CGFloat = 9
        let insetY: CGFloat = 9

        let textBox = SKSpriteNode(imageNamed: "textbox")
        let boxWidth = textBox.size.width
        let boxHeight = textBox.size.height
        textBox.centerRect = CGRect(x: insetX / boxWidth, y: insetY / boxHeight, width: (boxWidth - insetX * 2) / boxWidth, height: (boxHeight - insetY * 2) / boxHeight)
        textBox.xScale = size.width / boxWidth
        textBox.yScale = size.height / boxHeight
        addChild(textBox)
        
        createNumericButtons()
    }
    
    func createNumericButtons() {
        
        downButton.isHidden = false
        upButton.isHidden = false
    }
    
    func resetSelection() {
        
        number = 0
        text = String(format: "%0*d", maxTextLength, number)
    }
}

extension NumberSelectBox: NumericButtonDelegate {
    
    func numericButtonPushed(_ numericButton: NumericButton) {
        
        var maxNumber: Int = 1
        //figure out what the highest number possible is based on number of digits
        
        for _ in 0..<maxTextLength {
            maxNumber *= 10
        }
        
        //minus 1 from the max number to get the highest number with exactly the same number of digits 99, 999 etc.
        maxNumber -= 1
        
        if numericButton.numericDirection == .down {
            
            number -= 1
            if number < 0 {
                number = maxNumber
            }
        }
        else {
            
            number += 1
            if number > maxNumber {
                number = 0
            }
        }
        
        if delegate != nil && delegate?.numberSelectBoxDidStartEditing(numberSelectBox: self) != nil {
            delegate.numberSelectBoxDidStartEditing(numberSelectBox: self)
        }
        
        text = String(format: "%0*d", maxTextLength, number)
    }
}
