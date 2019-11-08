//
//  OptionSelectBox.swift
//  InterfaceControls
//
//  Created by ron myschuk on 2016-01-29.
//  Copyright © 2016 Orange Think Box. All rights reserved.
//

import Foundation
import SpriteKit

protocol OptionSelectBoxDataSource {
    
    func numberOfItems(optionSelectBox: OptionSelectBox) -> Int
    func allItems(optionSelectBox: OptionSelectBox) -> [String]
    func selectionAtIndex(optionSelectBox: OptionSelectBox, index: Int) -> String
}

protocol OptionSelectBoxDelegate {
    
    func optionSelectBoxDidStartEditing(optionSelectBox: OptionSelectBox)
}

class OptionSelectBox : SKSpriteNode {

    var dataSource: OptionSelectBoxDataSource!
    var delegate: OptionSelectBoxDelegate!
    var data: [String] = [String]()
    
    var blank: Bool = false
    var currentSelectionIndex: Int = 0
    
    //MARK: - Custom Properties

    var text: String = "" {
        
        didSet {
            textLabel.text = text
        }
    }
    
    var defaultText: String = "" {
        
        didSet {
            text = defaultText
        }
    }
    
    var initialText: String = "" {
        
        didSet {
            
            currentSelectionIndex = 0
            
            for item: String in dataSource.allItems(optionSelectBox: self) {
                
                if (initialText == item) {
                    
                    textLabel.fontColor = kTextColor
                    text = initialText
                    break
                }
                else {
                    currentSelectionIndex += 1
                }
            }
        }
    }
    
    //MARK: - Lazy Instantiations
    
    private lazy var backButton: DirectionButton = {
        
        //TODO: we need to make sure that this isn't being retained
        let button = DirectionButton(direction: .Back, size: CGSize(width: self.size.height, height: self.size.height))
        button.delegate = self
        button.position = CGPoint(x: (0 - self.size.width / 2) - button.size.width / 2, y: 0)
        button.zPosition = 10
        self.addChild(button)
        
        return button
    }()
    
    private lazy var forwardButton: DirectionButton = {
        
        let button = DirectionButton(direction: .Forward, size: CGSize(width: self.size.height, height: self.size.height))
        button.delegate = self
        button.position = CGPoint(x: self.size.width / 2 + button.size.width / 2, y: 0)
        button.zPosition = 10
        self.addChild(button)
        
        return button
    }()
    
    private lazy var textLabel: SKLabelNode = {
        
        let label = SKLabelNode(fontNamed: kTextBoxFont)
        label.fontColor = kDefaultTextColor
        label.fontSize = kTextBoxFontSize
        label.position = CGPoint(x: 0, y: -40)
        label.verticalAlignmentMode = .baseline
        label.horizontalAlignmentMode = .center
        label.zPosition = 2
        self.addChild(label)
        
        return label
    }()
    
    //MARK: - Init
    
    init(size: CGSize) {
        
        super.init(texture: nil ,color: .clear, size:size)
            
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        
        setup()
    }
    
    func setup() {
        
        isUserInteractionEnabled = true
        currentSelectionIndex = -1
        blank = true
        
        let insetX: CGFloat = 9
        let insetY: CGFloat = 9
        
        let textBox = SKSpriteNode(imageNamed: "textbox")
        textBox.centerRect = CGRect(x: insetX / textBox.size.width, y: insetY / textBox.size.height, width: (textBox.size.width - insetX * 2) / textBox.size.width, height: (textBox.size.height - insetY * 2) / textBox.size.height)
        textBox.xScale = size.width / textBox.size.width
        textBox.yScale = size.height / textBox.size.height
        addChild(textBox)
        
        createDirectionButtons()
    }
    
    func createDirectionButtons() {
        
        backButton.isHidden = false
        forwardButton.isHidden = false
    }
    
    func removeDefault() {
        
        if blank {
            text = ""
            textLabel.fontColor = kTextColor
        }
    }
    
    func resetDefault() {
        
        blank = true
        text = defaultText
        textLabel.fontColor = kDefaultTextColor
    }
}

extension OptionSelectBox: DirectionButtonDelegate {
    
    func directionButtonPushed(_ directionButton: DirectionButton) {
        
        let selectionCount: Int = dataSource.numberOfItems(optionSelectBox: self)
        
        if directionButton.direction == .Back {
            
            currentSelectionIndex -= 1
            if currentSelectionIndex < 0 {
                currentSelectionIndex = selectionCount - 1
            }
        }
        else {
            
            currentSelectionIndex += 1
            if currentSelectionIndex >= selectionCount {
                currentSelectionIndex = 0
            }
        }
        removeDefault()
        delegate.optionSelectBoxDidStartEditing(optionSelectBox: self)
        text = dataSource.selectionAtIndex(optionSelectBox: self, index: currentSelectionIndex)
    }
}
