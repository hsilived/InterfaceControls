//
//  GameScene.swift
//  InterfaceControls
//
//  Created by ron myschuk on 2016-01-28.
//  Copyright © 2016 Orange Think Box. All rights reserved.
//

import Foundation
import SpriteKit

class GameScene: SKScene {

    //, ColorPickerGridDataSource, ColorPickerGridDelegate {
    
    var data: [String]!
    var images: [String]!
    var colors: [String]!
    var keyboard: Keyboard!
    
    private var bottomY: CGFloat = 0
    
    private var textBoxTeamName: TextInputBox!
    private var optionSelectLocation: OptionSelectBox!
    private var textBoxStadium: TextInputBox!
    private var imageSelectLogo: ImageSelectBox!
    private var numberSelectQBNumberBox: NumberSelectBox!
    private var textBoxQBName: TextInputBox!
//    private var primaryColorPicker: ColorPickerGrid!
//    private var secondaryColorPicker: ColorPickerGrid!
//    private var skinToneColorPicker: ColorPickerGrid!
//    private var numbersColorPicker: ColorPickerGrid!
    
    override func didMove(to view: SKView) {
        
       setup()
    }
    
    func setup() {
        
        keyboard = Keyboard(scene: self)
        keyboard.dataSource = self
        
        kGameWidth = self.size.width
        kGameHeight = self.size.height
        
        if let ipadArea = self.childNode(withName: "ipad_area") as? SKSpriteNode {
                        
            bottomY = isIpad ? ipadArea.frame.minY : 0 - self.size.height / 2
            
            if isIpad {
                keyboard?.keyboardYOffset = 0 - self.size.height / 2 - bottomY
            }
        }
        
        data = ["Atlanta", "Baltimore", "Buffalo", "Charlotte", "Chicago", "Cincinatti", "Cleveland", "Dallas", "Denver", "Detroit", "Green Bay", "Houston", "Indianapolis", "Jacksonville", "Kansas City", "Miami", "Minneapolis", "Nashville", "New England", "New Orleans", "New York", "New York", "Oakland", "Philadelphia", "Phoenix", "Pittsburgh", "St Louis", "San Diego", "San Francisco", "Seattle", "Tampa", "Washington"]
        images = ["ace", "acorn", "apple", "cherry", "clover", "grapes", "heart", "jack", "jalapeno", "king", "lemon", "orange", "plum", "queen", "strawberry", "watermelon"]
        colors = ["170E0C", "471001", "8C7458", "CFAE6C", "F1C086", "FFFFFF", "C3C3C3", "9EA9AC", "000000", "4B8ACC", "0083CE", "001D8C", "001149", "000D22", "24004F", "4B00C0", "923ADE", "FF1578", "D6B22A", "CFE000", "6FA600", "00BF00", "002E0A", "002E23", "003446", "008994", "00A5E1", "B21A42", "872641", "E50C21", "A60707", "CC3201", "FF5000", "FF8400", "FFBB00", "AD7805"]
        
        if let textBoxTeamNameNode = childNode(withName: "//textBoxTeamName") as? TextInputBox {

            textBoxTeamNameNode.color = .clear
            textBoxTeamName = textBoxTeamNameNode
            textBoxTeamName.keyboard = keyboard!
            textBoxTeamName.defaultText = "TEAM NAME"
            textBoxTeamName.maxTextLength = 14
            textBoxTeamName.delegate = self
        }
        
        if let optionSelectLocationNode = childNode(withName: "//optionSelectLocation") as? OptionSelectBox {
             
            optionSelectLocationNode.color = .clear
            optionSelectLocation = optionSelectLocationNode
            optionSelectLocation.defaultText = "LOCATION"
            optionSelectLocation.dataSource = self
            optionSelectLocation.delegate = self
        }
        
        if let textBoxStadiumNode = childNode(withName: "//textBoxStadium") as? TextInputBox {
            
            textBoxStadiumNode.color = .clear
            textBoxStadium = textBoxStadiumNode
            textBoxStadium.keyboard =  keyboard!
            textBoxStadium.defaultText = "STADIUM NAME"
            textBoxStadium.maxTextLength = 14
            textBoxStadium.delegate = self
        }
        
        if let imageSelectLogoNode = childNode(withName: "//imageSelectLogo") as? SKSpriteNode {
            
            imageSelectLogoNode.color = .clear
            
            //[ImageSelectBox imageSelectBoxWithSize:CGSizeMake(660, 200)];
            imageSelectLogo = ImageSelectBox()//ImageSelectBox(coder: CGSize(width: CGFloat(660), height: CGFloat(200)))
            imageSelectLogo.delegate = self
            imageSelectLogo.dataSource = self
            imageSelectLogo.position = imageSelectLogoNode.position//CGPoint(x: 0, y: CGFloat((logoLabel?.position.y)! - padding - (imageSelectLogo?.size.height)! / 2))
            self.addChild(imageSelectLogo)
        }
        
//        let textBoxName = TextInputBox(keyboard: keyboard, size: CGSize(width: 300, height: 100))
//        textBoxName.defaultText = "NAME"
//        textBoxName.maxTextLength = 7
//        textBoxName.delegate = self
//        textBoxName.position = CGPoint(x: -210, y: 400)
//        addChild(textBoxName)
//
//        let numberSelectBox = NumberSelectBox(size: CGSize(width: 140, height: 100))
//        numberSelectBox.maxTextLength = 2
//        numberSelectBox.defaultText = "00"
//        numberSelectBox.delegate = self
//        numberSelectBox.position = CGPoint(x: 100, y: 400)
//        addChild(numberSelectBox)
//
//        let optionSelectBox = OptionSelectBox(size: CGSize(width: 520, height: 100))
//        optionSelectBox.defaultText = "CITY"
//        optionSelectBox.delegate = self
//        optionSelectBox.dataSource = self
//        optionSelectBox.position = CGPoint(x: 0, y: 220)
//        addChild(optionSelectBox)
//
//        let imageSelectBox = ImageSelectBox()//CGSizeMake(660, 200))
//        imageSelectBox.delegate = self
//        imageSelectBox.dataSource = self
//        imageSelectBox.position = CGPoint(x: 0, y: 0)
//        addChild(imageSelectBox)
        
//        var colorPickerGrid: ColorPickerGrid = ColorPickerGrid.colorPickerGridWithGridSize(CGSizeMake(9, 4), squareSize: 66)
//        colorPickerGrid.delegate = self
//        colorPickerGrid.dataSource = self
//        colorPickerGrid.position = CGPointMake(-colorPickerGrid.size.width / 2, -240 - colorPickerGrid.size.height / 2)
//        addChild(colorPickerGrid)
//        textBoxName.initialText = "DEVILS"
//        optionSelectBox.initialText = "Buffalo"
//        imageSelectBox.initialImage = "22"
//        colorPickerGrid.initialColor = "8C7458"
    }
    
    //MARK: - ColorPickerGridDataSource
    
//    func numberOfColors(colorPickerGrid: ColorPickerGrid) -> Int {
//        return colors.count
//    }
//    
//    func colorPickerGrid(colorPickerGrid: ColorPickerGrid, selectionAtIndex index: Int) -> String {
//        return colors[index]
//    }
    
    //MARK: - ColorPickerGridDelegate
    
//    func colorPickerGridDidStartEditing(colorPickerGrid: ColorPickerGrid) {
//        keyboard.dismiss()
//    }
}
        
//MARK: - ImageSelectBoxDataSource

extension GameScene: ImageSelectBoxDataSource {
        
    func numberOfImages(imageSelectBox: ImageSelectBox) -> Int {
        return images.count
    }
    
    func allImages(imageSelectBox: ImageSelectBox) -> [String] {
        return images
    }
    
    func imageSelectBox(imageSelectBox: ImageSelectBox, index: Int) -> String {
        return images[index]
    }
}
        
//MARK: - ImageSelectBoxDelegate

extension GameScene: ImageSelectBoxDelegate {
         
    func imageSelectBoxDidStartEditing(imageSelectBox: ImageSelectBox) {
        keyboard.dismiss()
    }
}
        
//MARK: - OptionSelectBoxDataSource

extension GameScene: OptionSelectBoxDataSource {
    
    func selectionAtIndex(optionSelectBox: OptionSelectBox, index: Int) -> String {
        return data[index]
    }
    
        
    func numberOfItems(optionSelectBox: OptionSelectBox) -> Int {
        return data.count
    }
    
    func allItems(optionSelectBox: OptionSelectBox) -> [String] {
        return data
    } 
}
        
//MARK: - OptionSelectBoxDelegate

extension GameScene: OptionSelectBoxDelegate {
        
    func optionSelectBoxDidStartEditing(optionSelectBox: OptionSelectBox) {
        keyboard.dismiss()
    }
}

// MARK: - KeyboardDelegate

extension GameScene: KeyboardDelegate {
    
    func keyboard(keyboard keyboardNode: Keyboard, didSelectCharacter: String) {}
    func keyboardDidHitDeleteKey(keyboard: Keyboard) {}
    func keyboardDidHitEnterKey() {}
}

//MARK: - KeyboardDataSource

extension GameScene: KeyboardDataSource {
    
    func numberOfSections(keyboard: Keyboard) -> Int {
        return Keyboard.qwertyAlphabetKeys().count
    }
    
    func numberOfItemsInSection(keyboard: Keyboard, section: Int) -> Int {
        return Keyboard.qwertyAlphabetKeys()[section].count
    }
    
    func characterAtIndexPath(keyboard: Keyboard, indexPath: IndexPath) -> String {
        return Keyboard.qwertyAlphabetKeys()[indexPath.section][indexPath.row]
    }
}
        
//MARK: - TextInputBoxDelegate

extension GameScene: TextInputBoxDelegate {
        
    func textInputNodeDidStartEditing(textInputNode textInputBox: TextInputBox) {
        
        for node: SKNode in children {
            
            //if ([node isKindOfClass: [TextInputBox class]]) {
            if (node is TextInputBox) {
                (node as! TextInputBox).editing = false
            }
        }
        textInputBox.editing = true
    }
    
    func textInputNodeDidChange(textInputNode: TextInputBox) {}
    
    func textInputNodeShouldClear(textInputNode: TextInputBox) -> Bool {
        return false
    }
}
    
//MARK: - NumberSelectBoxDelegate

extension GameScene: NumberSelectBoxDelegate {
        
    func numberSelectBoxDidStartEditing(numberSelectBox: NumberSelectBox) {}
}
