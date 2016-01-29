//
//  Keyboard
//  TextInputBox
//
//  Created by Ron Myschuk
//  Copyright (c) 2015 Orange Think Box. All rights reserved.
//

import Foundation
import SpriteKit

protocol KeyboardDataSource {

    func numberOfSectionsInKeyboard(keyboard: Keyboard) -> Int
    func keyboard(keyboard: Keyboard, numberOfItemsInSection section: Int) -> Int
    func keyboard(keyboard: Keyboard, characterAtIndexPath indexPath: NSIndexPath) -> String
}

protocol KeyboardDelegate {

    func keyboard(keyboardNode: Keyboard, didSelectCharacter character: String)
    func keyboardDidHitDeleteKey(keyboard: Keyboard)
    func keyboardDidHitEnterKey()
}

class Keyboard: SKSpriteNode {

    var dataSource: KeyboardDataSource?
    var delegate: KeyboardDelegate!
    var presented: Bool = false
    var currentScene: SKScene!
    var keyContainer: SKSpriteNode?
    //var qwertyAlphabetKeys: [AnyObject]!
    
    init(scene: SKScene) {

        super.init(texture: nil ,color: .clearColor(), size:CGSizeMake(scene.size.width, 100))

        //qwertyAlphabetKeys = [["Q", "W", "E", "R", "T", "Y", "U", "I", "O", "P", kKeyDelete], [kOffsetPadding, "A", "S", "D", "F", "G", "H", "J", "K", "L", kKeyEnter], [kKeyBlank, "Z", "X", "C", "V", "B", "N", "M", "&"], [kKeyBlank, kKeyBlank, kKeyBlank, kKeySpace, kKeyBlank, kKeyClose]]
        currentScene = scene
        self.zPosition = CGFloat.max
        self.position = CGPointMake(0, -scene.size.height)
        self.presented = false
        scene.addChild(self)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setDataSource(dataSource: KeyboardDataSource) {
        
        self.dataSource = dataSource
        self.createKeyboard()
    }

    func present() {

        if !self.presented {
            self.runAction(SKAction.moveTo(CGPointMake(self.position.x, -scene!.size.height / 2 + self.size.height / 2), duration: 0.2))
            self.presented = true
        }
    }

    func dismiss() {
        
        if self.presented {
            
            self.runAction(SKAction.moveTo(CGPointMake(self.position.x, -self.scene!.size.height), duration: 0.2))
            self.presented = false
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
        return UIEdgeInsetsMake(5.0, 5.0, 5.0, 5.0)
    }

    func keySize() -> CGSize {
        return CGSizeMake(77, 77)
    }

    func numberOfSections() -> Int {

        var numberOfSections: Int = 1
        
        if (self.dataSource != nil) {
            numberOfSections = self.dataSource!.numberOfSectionsInKeyboard(self)
        }
        //[self qwertyAlphabetKeys];
        return numberOfSections
    }

    func numberOfItemsInSection(section: Int) -> Int {
        return self.dataSource!.keyboard(self, numberOfItemsInSection: section)
    }

    func maximumNumberOfItems() -> Int {

        var maximumNumberOfItems: Int = 0
        
        for var i = 0; i < numberOfSections(); i++ {
            maximumNumberOfItems = max(maximumNumberOfItems, self.numberOfItemsInSection(i))
        }
        
        return maximumNumberOfItems
    }

    func createKeyboard() {

        if (keyContainer != nil) { return }

        //82 for ipad
        let keyWidth: CGFloat = ((size.width - marginInsets().left - marginInsets().right) - (kSpaceBetweenKeys * 10)) / 11
        let margins = marginInsets().top + marginInsets().bottom
        let height = (CGFloat(numberOfSections()) * keyWidth) + margins + (CGFloat(numberOfSections() - 1) * kSpaceBetweenKeys)
        let contentNodeSize: CGSize = CGSizeMake(size.width, height)
        size = contentNodeSize
        keyContainer = SKSpriteNode(color: SKColor(white: 0.6, alpha: 0.8), size: contentNodeSize)
        keyContainer!.position = CGPointMake(0, -self.size.height / 2 + keyContainer!.size.height / 2)
        addChild(keyContainer!)
        
        let initialKeyNodePosition: CGPoint = CGPointMake(-size.width / 2 + marginInsets().left, keyContainer!.size.height / 2 - keyWidth / 2 - kSpaceBetweenKeys - marginInsets().top)
        
        for i in 0..<numberOfSections() {
            
            var xPos: CGFloat = initialKeyNodePosition.x
            let yPos: CGFloat = initialKeyNodePosition.y - (CGFloat(i) * keyWidth) - CGFloat(i - 1) * kSpaceBetweenKeys;
            
            for var j = 0; j < self.numberOfItemsInSection(i); j++ {
                
                let character: String = dataSource!.keyboard(self, characterAtIndexPath: NSIndexPath(forItem: j, inSection: i))
                
                if (character == kOffsetPadding) {
                    xPos += keyWidth / 2 - kSpaceBetweenKeys
                }
                else if (character == kKeyBlank) {
                    xPos += keyWidth
                }
                else {
                    let key: Key = Key(character: character, size: CGSizeMake(keyWidth, keyWidth), target: self, action: "keyStroked:")
                    key.position = CGPointMake(xPos + key.size.width / 2, yPos)
                    keyContainer!.addChild(key)
                    xPos += key.size.width
                }

                xPos += kSpaceBetweenKeys
            }
        }
    }

    func keyStroked(keyNode: Key) {

        if (keyNode.name == kKeyDelete) {
            self.delegate.keyboardDidHitDeleteKey(self)
        }
        else if (keyNode.name == kKeyEnter) {
            self.delegate.keyboardDidHitEnterKey()
        }
        else if (keyNode.name == kKeySpace) {
            self.delegate.keyboard(self, didSelectCharacter: " ")
        }
        else if (keyNode.name == kKeyClose) {
            self.delegate.keyboardDidHitEnterKey()
        }
        else {
            self.delegate.keyboard(self, didSelectCharacter: keyNode.name!)
        }
    }

    class func qwertyAlphabetKeys() -> [[AnyObject]] {
        
        return [["Q", "W", "E", "R", "T", "Y", "U", "I", "O", "P", kKeyDelete], [kOffsetPadding, "A", "S", "D", "F", "G", "H", "J", "K", "L", kKeyEnter], [kKeyBlank, "Z", "X", "C", "V", "B", "N", "M", "&"], [kKeyBlank, kKeyBlank, kKeyBlank, kKeySpace, kKeyBlank, kKeyClose]]
    }
}