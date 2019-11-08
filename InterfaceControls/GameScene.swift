//
//  GameScene.swift
//  InterfaceControls
//
//  Created by ron myschuk on 2016-01-28.
//  Copyright © 2016 Orange Think Box. All rights reserved.
//

import Foundation
import SpriteKit
import UIKit

class GameScene: SKScene {

    let defaults: AppUserDefaults = AppUserDefaults()
    
    var data: [String]!
    var images: [String]!
    private var colors: [String]!
    private var puppyTones = [String]()
    var keyboard: Keyboard!
    
    private var bottomY: CGFloat = 0
    
    private var textBoxName: TextInputBox!
    private var optionSelectLocation: OptionSelectBox!
    private var imageSelectBox: ImageSelectBox!
    private var numberSelectBox: NumberSelectBox!
    private var favColorPicker: ColorPickerGrid!
    private var puppyColorPicker: ColorPickerGrid!
    private var colorPicker: ColorPicker!
    private var colorPickerButton: ColorPickerButton!
    private var colorPickerContainer: SKSpriteNode!
    private var controlColor: SKColor = SKColor.clouds()
    
    //saving and validation
    private var clearButton: Button!
    private var loadButton: Button!
    private var saveButton: Button!
    private var errorSound = SKAction.playSoundFileNamed("error.mp3", waitForCompletion: false)
    
    override func didMove(to view: SKView) {
        
       setup()
    }
    
    func setup() {
        
        kGameWidth = self.size.width
        kGameHeight = self.size.height
        
        if let iPadArea = self.childNode(withName: "ipad_area") as? SKSpriteNode {
                   
            let iPhoneArea = self.childNode(withName: "iphone_area") as? SKSpriteNode
            let iPhoneXArea = self.childNode(withName: "iphone_x_area") as? SKSpriteNode
            
            print("isIphoneX \(isIphoneX)")
            kGameWidth = isIpad ? iPadArea.frame.size.width : isIphoneX ? iPhoneXArea!.frame.size.width : iPhoneArea!.frame.size.width
            kGameHeight = isIpad ? iPadArea.frame.size.height : isIphoneX ? iPhoneXArea!.frame.size.height : iPhoneArea!.frame.size.height
            
            self.size = CGSize(width: kGameWidth, height: kGameHeight)
            
            bottomY = isIpad ? iPadArea.frame.minY : isIphoneX ? iPhoneXArea!.frame.minY + 100 : iPhoneArea!.frame.minY//isIpad ? iPadArea.frame.minY : 0 - self.size.height / 2
            
            //if isIpad {
                
            //}
        }
        
        keyboard = Keyboard(scene: self)
        keyboard.dataSource = self
        keyboard?.keyboardYOffset = 0 - self.size.height / 2 - bottomY
        
        data = ["Atlanta", "Baltimore", "Buffalo", "Charlotte", "Chicago", "Cincinatti", "Cleveland", "Dallas", "Denver", "Detroit", "Green Bay", "Houston", "Indianapolis", "Jacksonville", "Kansas City", "Miami", "Minneapolis", "Nashville", "New England", "New Orleans", "New York", "New York", "Oakland", "Philadelphia", "Phoenix", "Pittsburgh", "St Louis", "San Diego", "San Francisco", "Seattle", "Tampa", "Washington"]
        images = ["apple", "cherry", "grapes", "jalapeno", "lemon", "orange", "plum", "strawberry", "watermelon"]//["ace", "acorn", "apple", "cherry", "clover", "grapes", "heart", "jack", "jalapeno", "king", "lemon", "orange", "plum", "queen", "strawberry", "watermelon"]
        colors = ["170E0C", "471001", "8C7458", "CFAE6C", "F1C086", "FFFFFF", "C3C3C3", "9EA9AC", "000000", "4B8ACC", "0083CE", "001D8C", "001149", "000D22", "24004F", "4B00C0", "923ADE", "FF1578", "D6B22A", "CFE000", "6FA600", "00BF00", "002E0A", "002E23", "003446", "008994", "00A5E1", "B21A42", "872641", "E50C21", "A60707", "CC3201", "FF5000", "FF8400", "FFBB00", "AD7805"]
        puppyTones = ["000D22", "88654F", "E39555", "E2C399", "D28660", "EEEEEE", "DA955D", "A3572D", "CAAA91"]
        
        setupControls()
        
        setupButtons()
    }
        
    func setupButtons() {
        
        if let clearButton = childNode(withName: "clearButton") as? Button {
            self.clearButton = clearButton
            clearButton.quickSetUpWith(image: "button_blank_up")
            clearButton.createButtonText(buttonText: "CLEAR")
        }
        
        if let loadButton = childNode(withName: "loadButton") as? Button {
            self.loadButton = saveButton
            loadButton.quickSetUpWith(image: "button_blank_up")
            loadButton.createButtonText(buttonText: "LOAD")
        }
        
        if let saveButton = childNode(withName: "saveButton") as? Button {
            self.saveButton = saveButton
            saveButton.quickSetUpWith(image: "button_blank_up")
            saveButton.createButtonText(buttonText: "SAVE")
        }
    }
    
    func setupControls() {
                
        if let textBoxNameNode = childNode(withName: "//textBoxName") as? TextInputBox {

            textBoxNameNode.color = .clear
            textBoxName = textBoxNameNode
            textBoxName.keyboard = keyboard!
            textBoxName.defaultText = "USER NAME"
            textBoxName.maxTextLength = 14
            textBoxName.delegate = self
        }
        
        if let optionSelectLocationNode = childNode(withName: "//optionSelectLocation") as? OptionSelectBox {
             
            optionSelectLocationNode.color = .clear
            optionSelectLocation = optionSelectLocationNode
            optionSelectLocation.defaultText = "LOCATION"
            optionSelectLocation.dataSource = self
            optionSelectLocation.delegate = self
        }
        
        if let imageSelectLogoNode = childNode(withName: "//imageSelectLogo") as? SKSpriteNode {
            
            imageSelectLogoNode.color = .clear
            
            //[ImageSelectBox imageSelectBoxWithSize:CGSizeMake(660, 200)];
            imageSelectBox = ImageSelectBox()//ImageSelectBox(coder: CGSize(width: CGFloat(660), height: CGFloat(200)))
            imageSelectBox.delegate = self
            imageSelectBox.dataSource = self
            imageSelectBox.position = imageSelectLogoNode.position//CGPoint(x: 0, y: CGFloat((logoLabel?.position.y)! - padding - (imageSelectLogo?.size.height)! / 2))
            self.addChild(imageSelectBox)
        }
        
        if let primaryColorPickerNode = childNode(withName: "//primaryColorPicker") as? SKSpriteNode {
            
            primaryColorPickerNode.color = .clear
            
            favColorPicker = createColorsGrid(gridSize: ColorPickerGridCount(cols: 9, rows: 4))
            favColorPicker.position = CGPoint(x: 0 - favColorPicker.size.width / 2, y:  primaryColorPickerNode.position.y - favColorPicker.size.height / 2)
            self.addChild(favColorPicker)
        }
        
        if let skinToneColorPickerNode = childNode(withName: "//skinToneColorPicker") as? SKSpriteNode {
                        
            skinToneColorPickerNode.color = .clear
            
            puppyColorPicker = ColorPickerGrid(gridCount: ColorPickerGridCount(cols: 9, rows: 1), squareSize: 100)
            puppyColorPicker.name = "puppyTones"
            puppyColorPicker.dataSource = self
            puppyColorPicker.delegate = self
            puppyColorPicker.position = CGPoint(x: 0 - puppyColorPicker.size.width / 2, y:  skinToneColorPickerNode.position.y - puppyColorPicker.size.height / 2)
            self.addChild(puppyColorPicker!)
        }

        if let numberSelectBoxNode = childNode(withName: "//numberSelectBox") as? NumberSelectBox {
            
            numberSelectBoxNode.color = .clear
            
            numberSelectBox = numberSelectBoxNode
            numberSelectBox.maxTextLength = 2
            numberSelectBox.defaultText = "00"
            numberSelectBox.delegate = self
        }
                
        if let colorPicker = childNode(withName: "//colorPicker") as? ColorPicker {

            colorPicker.color = .clear
            self.colorPicker = colorPicker
            colorPicker.delegate = self
            colorPicker.createBackground(scene: self)
        }
    }
    
    func createColorsGrid(gridSize: ColorPickerGridCount) -> ColorPickerGrid {
        
        let colorPickerGrid = ColorPickerGrid(gridCount: gridSize, squareSize: 100)
        colorPickerGrid.dataSource = self
        colorPickerGrid.delegate = self
        
        return colorPickerGrid
    }
    
    // MARK: - Data Methods

    func clearData() {
        
        textBoxName.resetDefault()
        optionSelectLocation.resetDefault()
        imageSelectBox.resetSelectedImage()
        
        favColorPicker.resetSelectedColor()
        puppyColorPicker.resetSelectedColor()
        colorPicker.resetSelectedColor()
        
        numberSelectBox.resetSelection()
    }
    
    func loadData() {
        
        let savedData: [String: AnyObject] = defaults.getSavedData()!
   
        guard savedData.count > 0 else { return }
        
        textBoxName?.initialText = savedData["name"] as! String
        optionSelectLocation?.initialText = savedData["location"] as! String
        imageSelectBox?.initialImage = savedData["favFruit"] as! String
        numberSelectBox?.initialText = (savedData["favNumber"]?.stringValue)!
        
        //load this info regardless of default or not because there are default colors in place
        let primaryColor = savedData["favColor"]
        let puppyColor = savedData["puppyColor"]
        let popupColor = savedData["popupColor"]
        
        let color1 = (NSKeyedUnarchiver.unarchiveObject(with: primaryColor as! Data)! as? SKColor)!.hexString
        let color2 = (NSKeyedUnarchiver.unarchiveObject(with: puppyColor as! Data)! as? SKColor)!.hexString
        let color3 = (NSKeyedUnarchiver.unarchiveObject(with: popupColor as! Data)! as? SKColor)!.hexString
        
        favColorPicker?.initialColor = color1
        puppyColorPicker?.initialColor = color2
        colorPicker?.initialColor = color3
    }

    func saveData() {
        
        if !self.validateData() { return }
        
        let name = textBoxName!.text
        let location = optionSelectLocation!.text
        let favFruit = imageSelectBox!.image
        
        let favColor = favColorPicker.selectedColor
        let puppyColor = puppyColorPicker.selectedColor
        let popupColor = colorPicker.selectedColor
        
        let favNumber = Int((numberSelectBox?.text)!)
        
        defaults.setSavedData(name: name, location: location, favFruit: favFruit, favColor: favColor!, puppyColor: puppyColor!, popupColor: popupColor!, favNumber: favNumber!)
    }

    func validateData() -> Bool {

        if (textBoxName?.text == textBoxName?.defaultText) || (textBoxName?.text == "") {
            shakeNode(node: textBoxName!, howManyTimes: 3)
            self.run(errorSound)
            return false
        }
        
        if (optionSelectLocation?.text == optionSelectLocation?.defaultText) || (optionSelectLocation?.text == "") {
            shakeNode(node: optionSelectLocation!, howManyTimes: 3)
            self.run(errorSound)
            return false
        }
        
        if (favColorPicker?.selectedColor == nil) {
            shakeNode(node: favColorPicker!, howManyTimes: 3)
            self.run(errorSound)
            return false
        }
        
        if (puppyColorPicker?.selectedColor == nil) {
            shakeNode(node: puppyColorPicker!, howManyTimes: 3)
            self.run(errorSound)
            return false
        }
        
        if (colorPicker?.selectedColor == nil) {
             shakeNode(node: colorPicker!, howManyTimes: 3)
             self.run(errorSound)
             return false
         }
        
        return true
    }
    
    func shakeNode(node: SKNode, howManyTimes times: Int) {
        
        let xMoveDistance: CGFloat = 32
        let duration = 0.1
        
        let moveLeftStart = SKAction.moveBy(x: 0 - (xMoveDistance / 2), y: 0, duration: duration / 2)
        let moveRightEnd = SKAction.moveBy(x: (xMoveDistance / 2), y: 0, duration: duration / 2)
        let moveRight = SKAction.moveBy(x: xMoveDistance, y: 0, duration: duration)
        let moveLeft = SKAction.moveBy(x: 0 - xMoveDistance, y: 0, duration: duration)
        let moveSeq = SKAction.sequence([moveRight, moveLeft])
        let repeater = SKAction.repeat(moveSeq, count: times)
        let finalSeq = SKAction.sequence([moveLeftStart, repeater, moveRightEnd])
        
        node.run(finalSeq)
    }
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
        resetEditingOnAllTextBoxes()
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
        resetEditingOnAllTextBoxes()
        keyboard.dismiss()
    }
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
        
    func resetEditingOnAllTextBoxes() {
        
        for node in children {

            if (node is TextInputBox) {
                (node as! TextInputBox).editing = false
            }
        }
    }
    
    func textInputNodeDidStartEditing(textInputNode textInputBox: TextInputBox) {
        
        resetEditingOnAllTextBoxes()
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

// MARK: - ColorPickerGridDataSource

extension GameScene: ColorPickerGridDataSource {

    func numberOfColors(colorPickerGrid: ColorPickerGrid) -> Int {
        
        if (colorPickerGrid.name == "numbers") {
            return colors.count
        }
        else {
            return colors.count
        }
    }

    func colorPickerGrid(colorPickerGrid: ColorPickerGrid, selectionAtIndex index: Int) -> String {
        
        if (colorPickerGrid.name == "numbers") {
            return colors[index]
        }
        else if (colorPickerGrid.name == "puppyTones") {
            return puppyTones[index]
        }
        else {
            return colors[index]
        }
    }
}

// MARK: ColorPickerGridDelegate

extension GameScene: ColorPickerGridDelegate {

    func colorPickerGridDidStartEditing(colorPickerGrid: ColorPickerGrid) {
        resetEditingOnAllTextBoxes()
        keyboard?.dismiss()
    }
}

// MARK: ColorPickerDelegate

extension GameScene: ColorPickerDelegate {
       
    func colorPickerDidStartEditing(colorPicker: ColorPicker) {
        
        colorPicker.popupLocation = self.convert(self.convert(CGPoint.zero, from: self), to: colorPicker)
        resetEditingOnAllTextBoxes()
        keyboard?.dismiss()
    }
    
    func selected(color: SKColor) {
        
    }
    
    func hideColorPicker() {
        
    }
}

// MARK: ButtonDelegate

extension GameScene: ButtonDelegate {
    
    func buttonPressed(_: Button) { }
    
    func buttonReleased(_ button: Button) {
        
        guard button.isEnabled else { return }
        
        if button.name! == "saveButton" {
            saveData()
        }
        else if button.name! == "clearButton" {
            clearData()
        }
        else if button.name! == "loadButton" {
            loadData()
        }
    }
}
