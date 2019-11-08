//
//  Keyboard
//  TextInputBox
//
//  Created by Orange Think Box
//  Copyright (c) 2017 Orange Think Box. All rights reserved.
//

import Foundation
import SpriteKit

protocol KeyboardDataSource {

    func numberOfSections(keyboard: Keyboard) -> Int
    func numberOfItemsInSection(keyboard: Keyboard, section: Int) -> Int
    func characterAtIndexPath(keyboard: Keyboard, indexPath: IndexPath) -> String
}

protocol KeyboardDelegate {

    func keyboard(keyboard: Keyboard, didSelectCharacter: String)
    func keyboardDidHitDeleteKey(keyboard: Keyboard)
    func keyboardDidHitEnterKey()
}

class Keyboard: SKSpriteNode {

    var dataSource: KeyboardDataSource! {
        
        didSet {
            createKeyboard()
        }
    }
    
    var delegate: KeyboardDelegate!
    var presented = false
    var currentScene: SKScene!
    var keyContainer: SKSpriteNode?
    var keyboardYOffset: CGFloat = 0
    
    init(scene: SKScene) {

        super.init(texture: nil ,color: .clear, size: CGSize(width: scene.size.width, height: 100))

        currentScene = scene
        zPosition = 50000000
        isUserInteractionEnabled = true
        position = CGPoint(x: 0, y: -scene.size.height)
        presented = false
        scene.addChild(self)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func present() {//yPos: CGFloat = 0) {

        if !presented {
            
            run(SKAction.move(to: CGPoint(x: self.position.x, y: 0 - scene!.size.height / 2 + self.size.height / 2 + abs(keyboardYOffset)), duration: 0.2))
            presented = true
        }
    }

    func dismiss() {
        
        if presented {
            
            run(SKAction.move(to: CGPoint(x: self.position.x, y: 0 - self.scene!.size.height), duration: 0.2))
            presented = false
        }
    }

//    func removeFromParent() {
//
//        if self.presented {
//            self.dismiss()
//        }
//        super.removeFromParent()
//    }

    func marginInsets() -> UIEdgeInsets {
        return UIEdgeInsets(top: 20.0, left: 5.0, bottom: 20.0, right: 5.0)
    }

    func keySize() -> CGSize {
        return CGSize(width: 77, height: 77)
    }

    func numberOfSections() -> Int {

        var numberOfSections: Int = 1
        
        if (self.dataSource != nil) {
            numberOfSections = self.dataSource!.numberOfSections(keyboard: self)
        }
        //[self qwertyAlphabetKeys];
        return numberOfSections
    }

    func numberOfItemsInSection(section: Int) -> Int {
        return dataSource!.numberOfItemsInSection(keyboard: self, section: section)
    }

    func maximumNumberOfItems() -> Int {

        var maximumNumberOfItems: Int = 0
        
        for i in 0 ..< numberOfSections() {
            maximumNumberOfItems = max(maximumNumberOfItems, self.numberOfItemsInSection(section: i))
        }
        
        return maximumNumberOfItems
    }

    func createKeyboard() {

        guard keyContainer == nil else { return }

        //82 for ipad
        let keyWidth: CGFloat = ((size.width - marginInsets().left - marginInsets().right) - (kSpaceBetweenKeys * 10)) / 11
        let margins = marginInsets().top + marginInsets().bottom
        let height = (CGFloat(numberOfSections()) * keyWidth) + margins + (CGFloat(numberOfSections() - 1) * kSpaceBetweenKeys)
        let contentNodeSize: CGSize = CGSize(width: size.width, height: height)
        size = contentNodeSize
        
        keyContainer = SKSpriteNode(color: SKColor(white: 0.7, alpha: 0.8), size: contentNodeSize)
        keyContainer!.position = CGPoint(x: 0, y: (0 - self.size.height / 2) + keyContainer!.size.height / 2)
        keyContainer!.zPosition = 1
        keyContainer!.isUserInteractionEnabled = true
        addChild(keyContainer!)
        
        //this is basically oly for phones without a home button. just adds a little white space to the bottom of the keyboard
        let bottomBuffer = SKSpriteNode(color: SKColor(white: 0.7, alpha: 0.8), size: CGSize(width: contentNodeSize.width, height: 100))
        bottomBuffer.position = CGPoint(x: 0, y: keyContainer!.frame.minY - 50)
        bottomBuffer.zPosition = 1
        addChild(bottomBuffer)
        
        let initialKeyNodePosition: CGPoint = CGPoint(x: (0 - size.width / 2) + marginInsets().left, y: keyContainer!.size.height / 2 - keyWidth / 2 - kSpaceBetweenKeys - marginInsets().top)
        
        for i in 0..<numberOfSections() {
            
            var xPos: CGFloat = initialKeyNodePosition.x
            let yPos: CGFloat = initialKeyNodePosition.y - (CGFloat(i) * keyWidth) - CGFloat(i - 1) * kSpaceBetweenKeys;
            
            for j in 0..<self.numberOfItemsInSection(section: i) {
                
                let character: String = dataSource!.characterAtIndexPath(keyboard: self, indexPath: IndexPath(item: j, section: i))
                
                if (character == kOffsetPadding) {
                    xPos += keyWidth / 2 - kSpaceBetweenKeys
                }
                else if (character == kKeyBlank) {
                    xPos += keyWidth
                }
                else {
                    
                    let key = KeyButton(character: character, size: CGSize(width: keyWidth, height: keyWidth), target: self)
                    key.position = CGPoint(x: xPos + key.size.width / 2, y: yPos)
                    key.delegate = self
                    keyContainer!.addChild(key)
                    xPos += key.size.width
                }

                xPos += kSpaceBetweenKeys
            }
        }
    }

    class func qwertyAlphabetKeys() -> [[String]] {
        
        return [["Q", "W", "E", "R", "T", "Y", "U", "I", "O", "P", kKeyDelete], [kOffsetPadding, "A", "S", "D", "F", "G", "H", "J", "K", "L", kKeyEnter], [kKeyBlank, "Z", "X", "C", "V", "B", "N", "M", "&"], [kKeyBlank, kKeyBlank, kKeyBlank, kKeySpace, kKeyBlank, kKeyClose]]
    }
}

extension Keyboard: KeyButtonDelegate {
    
    func keyButtonPushed(_ keyNode: KeyButton) {
        
        if (keyNode.name == kKeyDelete) {
            delegate.keyboardDidHitDeleteKey(keyboard: self)
        }
        else if (keyNode.name == kKeyEnter) {
            delegate.keyboardDidHitEnterKey()
        }
        else if (keyNode.name == kKeySpace) {
            delegate.keyboard(keyboard: self, didSelectCharacter: " ")
        }
        else if (keyNode.name == kKeyClose) {
            delegate.keyboardDidHitEnterKey()
        }
        else {
            delegate.keyboard(keyboard: self, didSelectCharacter: keyNode.name!)
        }
    }
}
