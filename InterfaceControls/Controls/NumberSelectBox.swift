//
//  NumberSelectBox.swift
//  InterfaceControls
//
//  Created by ron myschuk on 2016-01-29.
//  Copyright © 2016 Orange Think Box. All rights reserved.
//

import Foundation
import SpriteKit

protocol NumberSelectBoxDelegate {
    func numberSelectBoxDidStartEditing(numberSelectBox: NumberSelectBox)
}

class NumberSelectBox: SKSpriteNode {
    
    var maxTextLength: Int = 0
    var number: Int = 0
    
    var delegate: NumberSelectBoxDelegate!
    
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
        
        let button = NumericButton(numericDirection: .Down, size: CGSize(width: self.size.height, height: self.size.height), target: self)
        button.delegate = self
        button.position = CGPoint(x: self.size.width / 2 + button.size.width / 2, y: 0)
        self.addChild(button)
        
        return button
    }()
    
    private lazy var upButton: NumericButton = {
        
        let button = NumericButton(numericDirection: .Up, size: CGSize(width: self.size.height, height: self.size.height), target: self)
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
        
        let textBox = SKSpriteNode(imageNamed: "textbox")
        let insetX: CGFloat = 9
        let insetY: CGFloat = 9
        let boxWidth = textBox.size.width
        let boxHeight = textBox.size.height
        print("number box size \(size)")
        print("boxWidth \(boxWidth)")
        print("boxHeight \(boxHeight)")
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
        
        if numericButton.numericDirection == .Down {
            
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
