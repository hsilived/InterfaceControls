//
//  ImageSelectBox.swift
//  DTS
//
//  Created by DeviL on 2016-01-11.
//  Copyright © 2016 Orange Think Box. All rights reserved.
//

import Foundation
import SpriteKit

//TextInputBox and OptionSelectBox Constants
let kOffsetSize: Int = 20
let kSpaceBetweenKeys: CGFloat = 10
let kAmountToMoveCaratForSpace: CGFloat = 18
let kTextboxFontSize: CGFloat = 52.0

let kTextBoxFont: String = "Helvetica"
let kGameFont: String = "Helvetica"
let kMiscFont: String = "Helvetica"
let kDefaultTextColor = SKColor(white: 0.4, alpha: 1.0)
let kTextColor = SKColor(white: 0.2, alpha: 1.0)

let kKeyDelete: String = "delete"
let kKeyEnter: String = "done"
let kKeySpace: String = "space"
let kKeyBlank: String = "blank"
let kKeyClose: String = "close"
let kOffsetPadding: String = "pad"

//#define OFFSET_SIZE                         20
//#define SPACE_BETWEEN_KEYS                  10
//#define AMOUNT_TO_MOVE_CARAT_FOR_SPACE      18




class ImageSelectionButton: SKSpriteNode {
    
    var number: Int = 0
    var selected: Bool = false {
        
        didSet {
            
            if selected {

                zPosition = 100
                let move: SKAction = SKAction.scaleTo(1.5, duration: 0.4)
                move.timingMode = .EaseInEaseOut
                runAction(move, withKey: "select")
            }
            else {

                removeActionForKey("select")
                
                zPosition = 1
                let move: SKAction = SKAction.scaleTo(1.0, duration: 0.15)
                move.timingMode = .EaseInEaseOut
                runAction(move)
            }
        }
    }
    
    init(imageName image: String, size: CGSize) {
        
        super.init(texture: nil ,color: .clearColor(), size:size)
        
        texture = SKTexture(imageNamed: image)
        
        self.size = texture!.size()
        
//        if texture!.size().width > texture!.size().height {
//            //wider than it is taller
//            self.size = CGSizeMake(width, texture!.size().height * size.width / texture!.size().width)
//        }
//        else {
//            //taller than it is wider
//            self.size = CGSizeMake((texture!.size().width * size.height) / texture!.size().height, size.height)
//        }
        
        zPosition = 2
        userInteractionEnabled = false
        name = image
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

protocol ImageSelectBoxDataSource {
    
    func numberOfImages(imageSelectBox: ImageSelectBox) -> Int
    func allImages(imageSelectBox: ImageSelectBox) -> [String]
    func imageSelectBox(imageSelectBox: ImageSelectBox, selectionAtIndex index: Int) -> String
}

protocol ImageSelectBoxDelegate {
    
    func imageSelectBoxDidStartEditing(imageSelectBox: ImageSelectBox)
}

class ImageSelectBox: SKSpriteNode {
    
    var selectedImage: ImageSelectionButton?
    var image: String = ""
    var initialImage: String = "" {
        
        didSet {
            
            var power: Int = -1
            
            for item: String in dataSource!.allImages(self) {
                
                if (image == item) {
                    
                    //self.image = image
                    //[self swipeLeft:Power];
                    currentImage += power + 1
                    imageContainer!.runAction(SKAction.moveToX(-(CGFloat(currentImage) * squareWidth + squareWidth / 2), duration: 0.0))
                    self.adjustPositionLabel()
                }
                else {
                    power++
                }
            }
        }
    }
    
    var dataSource: ImageSelectBoxDataSource? {
        
        didSet {
            
            currentImage = 0
            adjustPositionLabel()
            createImageSelector()
            image = self.dataSource!.imageSelectBox(self, selectionAtIndex: 0)
        }
    }
    
    var delegate: ImageSelectBoxDelegate?
    var data: [String] = [String]()
    
    var buttonSound: SKAction = SKAction()
    var textLabel: SKLabelNode = SKLabelNode()
    var caratSymbol: SKSpriteNode = SKSpriteNode()
    var blank: Bool = false
    var selections: [String] = [String]()
    
    var imageContainer: SKSpriteNode?
    var nameLabel: SKLabelNode = SKLabelNode()
    var currentSelectionIndex: Int = 0
    var imageCount: Int = 0
    var currentImage: Int = 0
    var squareSize: CGFloat = 0
    var squarePadding: CGFloat = 0
    var squareWidth: CGFloat = 0
    var squareHeight: CGFloat = 0
    var defaultPosition: CGFloat = 0
    var numberOfImagesToDisplay: Int = 0
    var maskWidth: CGFloat = 0
    var maskHeight: CGFloat = 0
    var maskControl: Bool = false
    var minimum_detect_distance: CGFloat = 0
    
    var initialPosition: CGPoint = CGPointZero
    var initialTouch: CGPoint = CGPointZero
    var moveAmtX: CGFloat = 0
    var moveAmtY: CGFloat = 0
    
    var images: [ImageSelectionButton] = [ImageSelectionButton]()
    
    init() {
        
        squarePadding = 40
        squareSize = 222
        squareWidth = (squareSize * 2) + squarePadding
        squareHeight = squareSize + squarePadding
        minimum_detect_distance = squareSize / CGFloat(2)
        defaultPosition = -squareSize / 2
        numberOfImagesToDisplay = 9
        
        let width = (CGFloat(numberOfImagesToDisplay) * squareSize) + (squarePadding * CGFloat(numberOfImagesToDisplay - 1))
        let height = squareSize + (squarePadding * 2)
        let size = CGSizeMake(width, height)
        maskWidth = size.width - squarePadding * 8
        maskHeight = size.height - squarePadding * 8
        
        super.init(texture: nil ,color: .clearColor(), size:size)

        self.size = size
        //self.keyboard = keyboard;
        userInteractionEnabled = true
        anchorPoint = CGPointMake(0.5, 0.5)
        //self.position = CGPointMake(-self.size.width / 2, 0);
        //currentSelectionIndex = -1
        blank = true
        
        nameLabel = SKLabelNode(fontNamed: kGameFont)
        nameLabel.fontColor = kDefaultTextColor
        nameLabel.text = ""
        nameLabel.fontSize = 44
        nameLabel.position = CGPointMake(0, 0)
        nameLabel.zPosition = 11
        nameLabel.verticalAlignmentMode = .Center
        nameLabel.horizontalAlignmentMode = .Center
        addChild(nameLabel)
        
        let outsideTexture: SKTexture = SKTexture(imageNamed: "imagebox")
        let outside: SKSpriteNode = SKSpriteNode(texture: outsideTexture)
        let insetX: CGFloat = 20
        let insetY: CGFloat = 20
        outside.centerRect = CGRectMake(insetX / outside.size.width, insetY / outside.size.height, (outside.size.width - insetX * 2) / outside.size.width, (outside.size.height - insetY * 2) / outside.size.height)
        outside.xScale = size.width / outside.size.width
        outside.yScale = size.height / outside.size.height
        outside.zPosition = 10
        outside.position = CGPointMake(0, 0)
        addChild(outside)
        
        let currentSelection: SKSpriteNode = SKSpriteNode(imageNamed: "image_selector_box")
        currentSelection.position = CGPointMake(0, self.size.height / 2)
        currentSelection.zPosition = 11
        addChild(currentSelection)
        
        buttonSound = SKAction.playSoundFileNamed("tap.wav", waitForCompletion: false)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

//    private lazy var detailLabel:UILabel = {
//        let label = UILabel()
//        label.textColor = UIColor.blackColor()
//        label.font = UIFont(name: “KannadaSangamMN”, size: 14.0)
//        self.addSubview(label)
//        return label
//    }()
    
    private lazy var positionLabel: SKLabelNode = {
        
        let posLabel = SKLabelNode(fontNamed: kMiscFont)
        posLabel.fontColor = kDefaultTextColor
        posLabel.fontSize = 30
        posLabel.position = CGPointMake(0, self.size.height / 2 + 20)
        posLabel.verticalAlignmentMode = .Center
        posLabel.horizontalAlignmentMode = .Center
        self.addChild(posLabel)

        return posLabel
    }()
    
    func imagesCount() -> Int {
        
        if imageCount > 0 {
            return imageCount
        }
        
        imageCount = 1
        
        if (self.dataSource != nil) {
            imageCount = self.dataSource!.numberOfImages(self)
        }
        
        return imageCount
    }
    
    func createImageSelector() {
        
        if imageContainer != nil { return }
        
        let width: CGFloat = CGFloat(imagesCount()) * squareSize + (CGFloat(imagesCount()) - 1) * squarePadding
        let height: CGFloat = squareSize + squarePadding * 2
        var lastPosX: CGFloat = 0
        var lastWidth: CGFloat = 0
        
        imageContainer = SKSpriteNode(color: .clearColor(), size: CGSizeMake(width, height))
        imageContainer!.anchorPoint = CGPointMake(0, 0.5)
        imageContainer!.zPosition = 20
        imageContainer!.position = CGPointMake(defaultPosition, 0)

        if maskControl {
            
            let mask: SKSpriteNode = SKSpriteNode(color: .blackColor(), size: CGSizeMake(maskWidth, maskHeight))
            mask.zPosition = 4800
            
            let cropNode: SKCropNode = SKCropNode()
            cropNode.zPosition = 20
            cropNode.maskNode = mask
            cropNode.addChild(imageContainer!)
            addChild(cropNode)
        }
        else {
            addChild(imageContainer!)
        }
        
        for imageIndex in 0..<imagesCount() {
            
            let imageBlock: ImageSelectionButton = ImageSelectionButton(imageName: self.dataSource!.imageSelectBox(self, selectionAtIndex: imageIndex), size: CGSizeMake(squareSize, squareSize))
            imageBlock.number = imageIndex
            imageBlock.position = CGPointMake(lastPosX + imageBlock.size.width / 2, 0)
            imageContainer!.addChild(imageBlock)
            
            lastWidth = imageBlock.size.width
            lastPosX = imageBlock.position.x + lastWidth / 2 + squarePadding
            
            images.append(imageBlock)
        }
        
        imageContainer!.size = CGSizeMake(lastPosX - squarePadding, height)
        
        //load first item name
        selectedImage = images[0]
        selectedImage?.selected = true
        nameLabel.text = selectedImage!.name?.replace("_", withString: " ")
    }
    
    func swipeLeft(power: Int) {
        
        if currentImage == imagesCount() - 1 {
            //they are on the last page and trying to go forwards so reset the page
            self.resetLevels()
            return
        }
        
        currentImage += power + 1
        
        if currentImage > imagesCount() - 1 {
            currentImage = imagesCount() - 1
        }
        self.xMoveActions(-(CGFloat(currentImage) * squareWidth + squareWidth / 2))
        self.adjustPositionLabel()
        self.image = self.dataSource!.imageSelectBox(self, selectionAtIndex: currentImage)
    }
    
    func swipeRight(power: Int) {
        
        if currentImage == 0 {
            //they are on the first page and trying to go backwards so reset the page
            self.resetLevels()
            return
        }
        
        currentImage -= power + 1
        
        if currentImage < 0 {
            currentImage = 0
        }
        
        //adjust the images scroll to the next or previous page based on their swipe direction
        self.xMoveActions(-(CGFloat(currentImage) * squareWidth + squareWidth / 2))
        self.adjustPositionLabel()
        self.image = self.dataSource!.imageSelectBox(self, selectionAtIndex: currentImage)
    }
    
    func adjustPositionLabel() {
        
        self.positionLabel.text = "\(currentImage + 1)/\(self.imagesCount)"
        self.delegate!.imageSelectBoxDidStartEditing(self)
    }
    
    func resetLevels() {
        
        NSLog("resetLevels")
        //if (currentImage == 0)
        //     return;
        //just reset the levels scroller to the central position based on whatever the current page is
        self.xMoveActions(-(CGFloat(currentImage) * squareWidth + squareWidth / 2))
        self.adjustPositionLabel()
    }
    
    func moveImagesLeft() {
        
        //print(cellHeight + padding)
        //xMoveActionsBy(squareWidth / 1.5)
        
        if currentSelectionIndex - 1 >= 0 {
            
            selectedImage?.selected = false
            
            let dist = images[currentSelectionIndex].position.x - images[currentSelectionIndex - 1].position.x
            
            xMoveActionsBy(dist / 1.5)
            
            currentSelectionIndex--
            
            let move: SKAction = SKAction.moveToY(self.size.height / 2 + 100, duration: 0.4)
            let scale: SKAction = SKAction.scaleTo(1.0, duration: 0.2)
            let group: SKAction = SKAction.group([move, scale])
            
            nameLabel.runAction(group)
            
            selectedImage = images[currentSelectionIndex]
            selectedImage?.selected = true
        }
        else {
            xMoveActionsBy(squareWidth / 1.5)
        }
    }
    
    func moveImagesRight() {
        
        //xMoveActionsBy(-squareWidth / 1.5)
        
        if currentSelectionIndex + 1 < images.count {
            
            selectedImage?.selected = false
            
            let dist = images[currentSelectionIndex + 1].position.x - images[currentSelectionIndex].position.x
            
            xMoveActionsBy(-dist / 1.5)
            //xMoveActions(images[currentSelectionIndex + 1].position.x)
            
            currentSelectionIndex++

            selectedImage = images[currentSelectionIndex]
            selectedImage?.selected = true
            nameLabel.text = selectedImage!.name?.replace("_", withString: " ")
        }
        else {
            xMoveActionsBy(-squareWidth / 1.5)
        }
    }

    func xMoveActionsBy(moveBy: CGFloat) {
        
        let move: SKAction = SKAction.moveByX((moveBy * 1.5), y: 0, duration: 0.3)
        move.timingMode = .EaseOut
        
        imageContainer!.runAction(move, completion: {
            self.checkForResetttingSlider()
        })
        
//        let dropBounce: SKTMoveEffect = SKTMoveEffect(node: imageContainer!, duration: 0.5, startPosition: imageContainer!.position, endPosition: CGPointMake(imageContainer!.position.x + moveBy, imageContainer!.position.y))
//        dropBounce.timingFunction = SKTTimingFunctionExtremeBackEaseOut
//        //move.timingMode = SKActionTimingEaseIn;
//        let move: SKAction = SKAction.actionWithEffect(dropBounce)
//        imageContainer!.runAction(move)
    }
    
    func xMoveActions(moveTo: CGFloat) {
        
        //this is the amount that we need to scroll the images selector
        //SKAction *move = [SKAction moveToX:moveTo duration:0.5];
        let dropBounce: SKTMoveEffect = SKTMoveEffect(node: imageContainer!, duration: 0.5, startPosition: imageContainer!.position, endPosition: CGPointMake(moveTo, imageContainer!.position.y))
        dropBounce.timingFunction = SKTTimingFunctionExtremeBackEaseOut
        //move.timingMode = SKActionTimingEaseIn;
        let move: SKAction = SKAction.actionWithEffect(dropBounce)
        imageContainer!.runAction(move)
    }
    
//    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
//
//        //        for touch in touches {
//        //
//        //            let location = touch.locationInNode(self)
//
//        if let touch = touches.first as UITouch! {
//
//            //let touchLocation = touch.locationInView(self.scene!.view)
//
//            self.scrollCell.removeAllActions()
//            //var touch: UITouch = touches.anyObject()
//            initialTouch = touch.locationInView(self.scene!.view)
//            moveAmtY = 0
//            initialPosition = self.scrollCell.position
//            //initialMenuPosition = menuScene().menuScroller.position
//            menuScene().touchesBegan(touches, withEvent: event)
//        }
//    }

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        let touch: UITouch = touches.first!
        initialTouch = touch.locationInView(self.scene!.view!)
        let positionInScene: CGPoint = touch.locationInNode(self)
        
        for node: SKNode in nodesAtPoint(positionInScene) {
            
            if (node is ImageSelectionButton) {
                
                selectedImage = node as? ImageSelectionButton
//                if gameModel.soundEffects {
                    runAction(buttonSound)
//                }
            }
        }
        moveAmtY = 0
        moveAmtX = 0
        initialPosition = imageContainer!.position
    }
    
//    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
//
//        if let touch = touches.first as UITouch! {
//
//            //var touch: UITouch = touches.anyObject()
//            let movingPoint: CGPoint = touch.locationInView(self.scene!.view)
//            moveAmtX = movingPoint.x - initialTouch.x
//            moveAmtY = movingPoint.y - initialTouch.y
//            scrollCell.position = CGPointMake(initialPosition.x, initialPosition.y - moveAmtY)
//
//            if moveAmtX > minimum_detect_distance {
//                menuScene().touchesMoved(touches, withEvent: event)
//            }
//
//            checkForResetttingSlider()
//        }
//    }

    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        let touch: UITouch = touches.first!
        let movingPoint: CGPoint = touch.locationInView(self.scene!.view!)
        moveAmtX = movingPoint.x - initialTouch.x
        moveAmtY = movingPoint.y - initialTouch.y
        imageContainer!.position = CGPointMake(initialPosition.x + moveAmtX, initialPosition.y)
    }
    
//    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
//
//        checkForResetttingSlider()
//        yMoveActions(-moveAmtY)
//
//        menuScene().touchesEnded(touches, withEvent: event)
//    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        //they havent moved far enough so just reset the page to the original position
        if abs(moveAmtX) > 0 && abs(moveAmtX) < minimum_detect_distance {
            resetLevels()
        }
        
        let power: Int = abs(Int(moveAmtX) / Int(squareSize)) * 2
        //the user has swiped past the designated distance, so assume that they want the page to scroll
        
        if moveAmtX < -minimum_detect_distance {
            swipeLeft(power)
        }
        else if moveAmtX > minimum_detect_distance {
            swipeRight(power)
        }
        else {
            
            if selectedImage != nil {
                
                if currentImage > selectedImage!.number {
                    swipeRight(currentImage - selectedImage!.number - 1)
                }
                else {
                    swipeLeft(selectedImage!.number - currentImage - 1)
                }
            }
        }
    }
    
    func checkForResetttingSlider() {

        let scrollDif: CGFloat = abs(imageContainer!.size.width - size.width) / 2.0

        print("\nscrollDif \(scrollDif)")
        print("imageContainer!.position.x \(imageContainer!.position.x)")
        print("imageContainer!.width \(imageContainer!.size.width)")
        
        //moving the slider right
        if imageContainer!.position.x > 0 {

            let move: SKAction = SKAction.moveToX(-squareSize / 2, duration: 0.2)
            move.timingMode = .EaseOut
            imageContainer!.runAction(move)
        }

        //moving the slider left
        if imageContainer!.position.x < -(imageContainer!.size.width) {

            let move: SKAction = SKAction.moveToX(-(imageContainer!.size.width - squareSize / 2), duration: 0.2)
            move.timingMode = .EaseOut
            imageContainer!.runAction(move)
        }
        
//        if selectedImage != nil {
//            
//            if currentImage > selectedImage!.number {
//                swipeRight(currentImage - selectedImage!.number - 1)
//            }
//            else {
//                swipeLeft(selectedImage!.number - currentImage - 1)
//            }
//        }
    }
}

