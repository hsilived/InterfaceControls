//
//  GameScene.swift
//  InterfaceControls
//
//  Created by ron myschuk on 2016-01-28.
//  Copyright © 2016 Orange Think Box. All rights reserved.
//

import Foundation
import SpriteKit

class GameScene: SKScene, KeyboardDataSource, TextInputBoxDelegate, ImageSelectBoxDataSource, ImageSelectBoxDelegate {//, ColorPickerGridDataSource, ColorPickerGridDelegate, NumberSelectBoxDelegate, OptionSelectBoxDelegate, OptionSelectBoxDataSource {
    
    var data: [AnyObject]!
    var images: [String]!
    var colors: [String]!
    var keyboard: Keyboard!
    
    override init(size: CGSize) {
        
        super.init(size: size)
            
        data = ["Atlanta", "Baltimore", "Buffalo", "Charlotte", "Chicago", "Cincinatti", "Cleveland", "Dallas", "Denver", "Detroit", "Green Bay", "Houston", "Indianapolis", "Jacksonville", "Kansas City", "Miami", "Minneapolis", "Nashville", "New England", "New Orleans", "New York", "New York", "Oakland", "Philadelphia", "Phoenix", "Pittsburgh", "St Louis", "San Diego", "San Francisco", "Seattle", "Tampa", "Washington"]
        images = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25"]
        colors = ["170E0C", "471001", "8C7458", "CFAE6C", "F1C086", "FFFFFF", "C3C3C3", "9EA9AC", "000000", "4B8ACC", "0083CE", "001D8C", "001149", "000D22", "24004F", "4B00C0", "923ADE", "FF1578", "D6B22A", "CFE000", "6FA600", "00BF00", "002E0A", "002E23", "003446", "008994", "00A5E1", "B21A42", "872641", "E50C21", "A60707", "CC3201", "FF5000", "FF8400", "FFBB00", "AD7805"]
        
        anchorPoint = CGPointMake(0.5, 0.5)
        keyboard = Keyboard(scene: self)
        keyboard.dataSource = self
        
        let background: SKSpriteNode = SKSpriteNode(color: SKColor(red: 232 / 255.0, green: 232 / 255.0, blue: 224 / 255.0, alpha: 1.0), size: size)
        background.size = size
        background.zPosition = -1
        addChild(background)
        
        let textBoxName: TextInputBox = TextInputBox(keyboard: keyboard, size: CGSizeMake(300, 100))
        textBoxName.defaultText = "NAME"
        textBoxName.maxTextLength = 7
        textBoxName.delegate = self
        textBoxName.position = CGPointMake(-210, 400)
        addChild(textBoxName)
        
//        var numberSelectBox: NumberSelectBox = NumberSelectBox.numberSelectBoxWithSize(CGSizeMake(140, 100))
//        numberSelectBox.maxTextLength = 2
//        numberSelectBox.defaultText = "00"
//        numberSelectBox.delegate = self
//        numberSelectBox.position = CGPointMake(100, 400)
//        addChild(numberSelectBox)
//        
//        var optionSelectBox: OptionSelectBox = OptionSelectBox.optionSelectBoxWithSize(CGSizeMake(520, 100))
//        optionSelectBox.defaultText = "CITY"
//        optionSelectBox.delegate = self
//        optionSelectBox.dataSource = self
//        optionSelectBox.position = CGPointMake(0, 200)
//        addChild(optionSelectBox)
        
        let imageSelectBox: ImageSelectBox = ImageSelectBox()//CGSizeMake(660, 200))
        imageSelectBox.delegate = self
        imageSelectBox.dataSource = self
        imageSelectBox.position = CGPointMake(0, 0)
        addChild(imageSelectBox)
        
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

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
    
    //MARK: - ImageSelectDataSource

    func numberOfImages(imageSelectBox: ImageSelectBox) -> Int {
        return images.count
    }
    
    func allImages(imageSelectBox: ImageSelectBox) -> [String] {
        return images
    }
    
    func imageSelectBox(imageSelectBox: ImageSelectBox, selectionAtIndex index: Int) -> String {
        return images[index]
    }
    
    //MARK: - ImageSelectDelegate
    
    func imageSelectBoxDidStartEditing(imageSelectBox: ImageSelectBox) {
        keyboard.dismiss()
    }
    
    //MARK: - OptionSelectDataSource
    
//    func numberOfItems(optionSelectBox: OptionSelectBox) -> Int {
//        return data.count
//    }
//    
//    func allItems(optionSelectBox: OptionSelectBox) -> [AnyObject] {
//        return data
//    }
//    
//    func optionSelectBox(optionSelectBox: OptionSelectBox, selectionAtIndex index: Int) -> String {
//        return data[index]
//    }
    
    //MARK: - OptionSelectDelegate
    
//    func optionSelectBoxDidStartEditing(optionSelectBox: OptionSelectBox) {
//        keyboard.dismiss()
//    }
    
    //MARK: - KeyboardDataSource
    
    func numberOfSectionsInKeyboard(keyboard: Keyboard) -> Int {
        return Keyboard.qwertyAlphabetKeys().count
    }
    
    func keyboard(keyboard: Keyboard, numberOfItemsInSection section: Int) -> Int {
        return Keyboard.qwertyAlphabetKeys()[section].count
    }
    
    func keyboard(keyboard: Keyboard, characterAtIndexPath indexPath: NSIndexPath) -> String {
        
        return Keyboard.qwertyAlphabetKeys()[indexPath.section][indexPath.row] as! String
    }
    
    //MARK: - TextInputBoxDelegate
    
    func textInputNodeDidStartEditing(textInputBox: TextInputBox) {
        
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