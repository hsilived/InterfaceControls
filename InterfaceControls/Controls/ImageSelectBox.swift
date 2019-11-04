//
//  ImageSelectBox.swift
//  Nuke & Juke
//
//  Created by DeviL on 2016-01-11.
//  Copyright © 2016 Orange Think Box. All rights reserved.
//

import Foundation
import SpriteKit

protocol ImageSelectionButtonDelegate: NSObjectProtocol {
    func ImageWasSelected(imageSelectionButton: ImageSelectionButton)
}

class ImageSelectionButton: SKSpriteNode {
    
    weak var delegate: ImageSelectionButtonDelegate?
    var imageParent: ImageSelectBox?
    var number: Int = 0
    var selected: Bool = false {
        
        didSet {
            
            if selected {

                zPosition = 100
                let move: SKAction = SKAction.scale(to: 1.5, duration: 0.4)
                move.timingMode = .easeInEaseOut
                run(move, withKey: "select")
            }
            else {

                removeAction(forKey: "select")
                
                zPosition = 1
                let move: SKAction = SKAction.scale(to: 1.0, duration: 0.15)
                move.timingMode = .easeInEaseOut
                run(move)
            }
        }
    }
    
    init(imageName image: String, size: CGSize) {
        
        super.init(texture: nil ,color: .clear, size:size)
        
        texture = SKTexture(imageNamed: image)
        
        self.size = texture!.size()
        zPosition = 2
        isUserInteractionEnabled = true
        name = image
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent!)  {
        if imageParent != nil {
            imageParent!.touchesBegan(touches, with: event)
        }
    }
    
    //If the Button is enabled: This method looks, where the touch was moved to. If the touch moves outside of the button, the isSelected property is restored to NO and the texture changes to "normalTexture".
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent!)  {
        
        if imageParent != nil {
            imageParent!.touchesMoved(touches, with: event)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent!) {
        
        if imageParent != nil {
            imageParent!.touchesEnded(touches, with: event)
            
            print("imageParent!.moveAmtX \(imageParent!.moveAmtX)")
            if abs(imageParent!.moveAmtX) > 5 {
                return
            }
        }
        
        delegate!.ImageWasSelected(imageSelectionButton: self)
    }
}

protocol ImageSelectBoxDataSource {
    
    func numberOfImages(imageSelectBox: ImageSelectBox) -> Int
    func allImages(imageSelectBox: ImageSelectBox) -> [String]
    func imageSelectBox(imageSelectBox: ImageSelectBox, index: Int) -> String
}

protocol ImageSelectBoxDelegate {
    
    func imageSelectBoxDidStartEditing(imageSelectBox: ImageSelectBox)
}

class ImageSelectBox: SKSpriteNode, ImageSelectionButtonDelegate {
    
    var selectedImage: ImageSelectionButton?
    var image: String = ""
    var initialImage: String = "" {
        
        didSet {
            
            var power: Int = 0
            
            for item: String in dataSource!.allImages(imageSelectBox: self) {
                
                if (initialImage == item) {
                    
                    self.image = initialImage
                    self.swipeLeft(power: power)
                    //currentImageIndex += power + 1
                    //imageContainer!.run(SKAction.moveTo(x: -(CGFloat(currentImageIndex) * squareWidth + squareWidth / 2), duration: 0.0))
                    //self.adjustPositionLabel()
                }
                else {
                    power += 1
                }
            }
        }
    }
    
    var dataSource: ImageSelectBoxDataSource? {
        
        didSet {
            
            currentImageIndex = 0
            adjustPositionLabel()
            createImageSelector()
            image = self.dataSource!.imageSelectBox(imageSelectBox: self, index: 0)
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
    var currentSelectionIndex: Int = 0
    var imageCount: Int = 0
    var currentImageIndex: Int = 0
    var squareSize: CGFloat = 0
    var padding: CGFloat = 0
    var squareWidth: CGFloat = 0
    var squareHeight: CGFloat = 0
    var defaultPosition: CGFloat = 0
    var numberOfImagesToDisplay: Int = 0
    var maskWidth: CGFloat = 0
    var maskHeight: CGFloat = 0
    var maskControl: Bool = true
    var minimum_detect_distance: CGFloat = 0
    
    var initialPosition: CGPoint = CGPoint.zero
    var initialTouch: CGPoint = CGPoint.zero
    var moveAmtX: CGFloat = 0
    var moveAmtY: CGFloat = 0
    
    var images: [ImageSelectionButton] = [ImageSelectionButton]()
    
    //MARK: - Lazy Instantiations
    
    private lazy var positionLabel: SKLabelNode = {
        
        let posLabel = SKLabelNode(fontNamed: kMiscFont)
        posLabel.fontColor = kDefaultTextColor
        posLabel.fontSize = 60
        posLabel.position = CGPoint(x: self.size.width / 2 - 60, y: self.size.height / 2 + 40)
        posLabel.verticalAlignmentMode = .center
        posLabel.horizontalAlignmentMode = .center
        self.addChild(posLabel)
        
        return posLabel
    }()
    
    //MARK: - init
    
    init() {
        
        padding = 10
        squareSize = 240
        squareWidth = squareSize
        squareHeight = squareSize
        minimum_detect_distance = 40
        defaultPosition = -squareSize / 2
        numberOfImagesToDisplay = 5
        
        let width = (CGFloat(numberOfImagesToDisplay) * squareSize) + (padding * CGFloat(numberOfImagesToDisplay - 1))
        let height = squareSize + (padding * 2)
        let size = CGSize(width: width, height: height)
        maskWidth = width
        maskHeight = height
        
        super.init(texture: nil ,color: .clear, size:size)

        self.size = size
        isUserInteractionEnabled = true
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        blank = true
        
        let outside: SKSpriteNode = SKSpriteNode(imageNamed: "imagebox")
        let insetX: CGFloat = 20
        let insetY: CGFloat = 20
        let boxWidth = outside.size.width
        let boxHeight = outside.size.height
        outside.centerRect = CGRect(x: insetX / boxWidth, y: insetY / boxHeight, width: (boxWidth - insetX * 2) / boxWidth, height: (boxHeight - insetY * 2) / boxHeight)
        outside.xScale = size.width / boxWidth
        outside.yScale = size.height / boxHeight
        outside.zPosition = 10
        addChild(outside)
        
        let currentSelection: SKSpriteNode = SKSpriteNode(imageNamed: "image_selector_box")
        currentSelection.position = CGPoint(x: 0, y: self.size.height / 2)
        currentSelection.setScale(2.0)
        currentSelection.zPosition = 11
        addChild(currentSelection)
        
        buttonSound = SKAction.playSoundFileNamed("tap.caf", waitForCompletion: false)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func imageCounter() -> Int {
        
        if imageCount > 0 {
            return imageCount
        }
        
        imageCount = 1
        
        if (self.dataSource != nil) {
            imageCount = self.dataSource!.numberOfImages(imageSelectBox: self)
        }
        
        return imageCount
    }
    
    func createImageSelector() {
        
        if imageContainer != nil { return }
        
        let imageCount = imageCounter()
        
        //let width: CGFloat = CGFloat(imageCount) * squareSize + (CGFloat(imageCount) - 1) * padding
        //let height: CGFloat = squareSize + padding * 2
        var lastPosX: CGFloat = 0
        var lastWidth: CGFloat = 0
        
        imageContainer = SKSpriteNode(color: .clear, size: CGSize(width: self.size.width, height: self.size.height))
        imageContainer!.anchorPoint = CGPoint(x: 0, y: 0.5)
        imageContainer!.zPosition = 20
        imageContainer!.position = CGPoint(x: defaultPosition, y: 0)

        if maskControl {
            
            let mask: SKSpriteNode = SKSpriteNode(color: .black, size: CGSize(width: maskWidth, height: maskHeight))
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
        
        for imageIndex in 0..<imageCount {
            
            let imageBlock: ImageSelectionButton = ImageSelectionButton(imageName: self.dataSource!.imageSelectBox(imageSelectBox: self, index: imageIndex), size: CGSize(width: squareSize, height: squareSize))
            imageBlock.number = imageIndex
            imageBlock.position = CGPoint(x: lastPosX + squareSize / 2, y: 0)
            imageBlock.delegate = self
            imageBlock.imageParent = self
            imageContainer!.addChild(imageBlock)
            
            lastWidth = squareSize
            lastPosX = imageBlock.position.x + lastWidth / 2 + padding
            
            images.append(imageBlock)
        }
        
       // imageContainer!.size = CGSize(width: lastPosX - padding, height: height)
        
        //load first item name
        selectedImage = images[0]
        selectedImage?.selected = true
    }
    
    func ImageWasSelected(imageSelectionButton: ImageSelectionButton) {
        
        //selectedImageIndex = imageSelectionButton.number
        //print("focusOnSelection - avatarBuilderCell.index \(avatarBuilderCell.index)")
        //print("currentImageIndex \(currentImageIndex)")
        if imageSelectionButton.number > currentImageIndex {
            swipeLeft(power: imageSelectionButton.number - currentImageIndex)
        }
        else if imageSelectionButton.number < currentImageIndex {
            swipeRight(power: currentImageIndex - imageSelectionButton.number)
        }
    }
    
    func swipeLeft(power: Int) {
        
        let imageCount = imageCounter()
        
        print("starting on Image \(currentImageIndex)")
        print("power \(power)")
        currentImageIndex = currentImageIndex + power > imageCount - 1 ? imageCount - 1 : currentImageIndex + power
        currentImageIndex = currentImageIndex < 0 ? 0 : currentImageIndex
        currentImageIndex = currentImageIndex >= imageCount ? imageCount - 1 : currentImageIndex
        
        print("moving to Image \(currentImageIndex)")
        print("squareWidth \(squareWidth)")
        print("padding \(padding)")
        self.xMoveActions(moveTo: -(CGFloat(currentImageIndex) * (squareSize + padding) + squareSize / 2))
        
        self.adjustPositionLabel()
        self.image = self.dataSource!.imageSelectBox(imageSelectBox: self, index: currentImageIndex)
    }
    
    func swipeRight(power: Int) {
        
        if currentImageIndex == 0 {
            //they are on the first page and trying to go backwards so reset the page
            resetSlider()
            return
        }
        
        currentImageIndex -= power
        currentImageIndex = currentImageIndex < 0 ? 0 : currentImageIndex
        
        //adjust the images scroll to the next or previous page based on their swipe direction
        self.xMoveActions(moveTo: -(CGFloat(currentImageIndex) * (squareSize + padding) + squareSize / 2))
        self.adjustPositionLabel()
        self.image = self.dataSource!.imageSelectBox(imageSelectBox: self, index: currentImageIndex)
    }
    
    func adjustPositionLabel() {
        
        let imageCount = imageCounter()
        
        self.positionLabel.text = "\(currentImageIndex + 1)/\(imageCount)"
        self.delegate!.imageSelectBoxDidStartEditing(imageSelectBox: self)
    }
    
    func resetSlider() {
        
        print("resetSlider")
        //if (currentImage == 0)
        //     return;
        //just reset the levels scroller to the central position based on whatever the current page is
        self.xMoveActions(moveTo: -(CGFloat(currentImageIndex) * squareWidth + squareWidth / 2))
        self.adjustPositionLabel()
    }
    
    func moveImagesLeft() {
        
        //print(cellHeight + padding)
        //xMoveActionsBy(squareWidth / 1.5)
        
        if currentSelectionIndex - 1 >= 0 {
            
            selectedImage?.selected = false
            
            let dist = images[currentSelectionIndex].position.x - images[currentSelectionIndex - 1].position.x
            
            xMoveActionsBy(moveBy: dist / 1.5)
            
            currentSelectionIndex -= 1
            
            selectedImage = images[currentSelectionIndex]
            selectedImage?.selected = true
        }
        else {
            xMoveActionsBy(moveBy: squareWidth / 1.5)
        }
    }
    
    func moveImagesRight() {
        
        //xMoveActionsBy(-squareWidth / 1.5)
        
        if currentSelectionIndex + 1 < images.count {
            
            selectedImage?.selected = false
            
            let dist = images[currentSelectionIndex + 1].position.x - images[currentSelectionIndex].position.x
            
            xMoveActionsBy(moveBy: -dist / 1.5)
            //xMoveActions(images[currentSelectionIndex + 1].position.x)
            
            currentSelectionIndex += 1

            selectedImage = images[currentSelectionIndex]
            selectedImage?.selected = true
        }
        else {
            xMoveActionsBy(moveBy: -squareWidth / 1.5)
        }
    }

    func xMoveActionsBy(moveBy: CGFloat) {
        
        let move: SKAction = SKAction.moveBy(x: (moveBy * 1.5), y: 0, duration: 0.3)
        move.timingMode = .easeOut
        
        imageContainer!.run(move, completion: {
            self.checkForResetttingSlider()
        })
        
//        let dropBounce: SKTMoveEffect = SKTMoveEffect(node: imageContainer!, duration: 0.5, startPosition: imageContainer!.position, endPosition: CGPoint(x: imageContainer!.position.x + moveBy, y: imageContainer!.position.y))
//        dropBounce.timingFunction = SKTTimingFunctionExtremeBackEaseOut
//        //move.timingMode = .easeIn;
//        let move: SKAction = SKAction.actionWithEffect(dropBounce)
//        imageContainer!.run(move)
    }
    
    func xMoveActions(moveTo: CGFloat) {
        
        print("moveTo \(moveTo)")
        let dropBounce: SKTMoveEffect = SKTMoveEffect(node: imageContainer!, duration: 0.5, startPosition: imageContainer!.position, endPosition: CGPoint(x: moveTo, y: imageContainer!.position.y))
        dropBounce.timingFunction = SKTTimingFunctionExtremeBackEaseOut
        //move.timingMode = SKActionTimingEaseIn;
        let move = SKAction.actionWith(effect: dropBounce)
        
        if self.currentImageIndex < 0 {
            self.currentImageIndex = 0
        }
        //print("xMoveActions currentImageIndex \(currentImageIndex)")
        //print("type \(type)")
        imageContainer!.run(move, completion: {
            
            if self.currentImageIndex < 0 {
                self.currentImageIndex = 0
            }
            self.selectedImage = self.images[self.currentImageIndex]
        } )
        //imageContainer!.run(move)
    }
    
    //MARK: - Touch methods
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let touch: UITouch = touches.first!
        initialTouch = touch.location(in: self.scene!.view!)
        moveAmtY = 0
        moveAmtX = 0
        initialPosition = imageContainer!.position
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let touch: UITouch = touches.first!
        let movingPoint: CGPoint = touch.location(in: self.scene!.view!)
        moveAmtX = movingPoint.x - initialTouch.x
        moveAmtY = movingPoint.y - initialTouch.y
        
 //       if type == .colors {
 //           imageContainer!.position = CGPoint(x: initialPosition.x + moveAmtX, y: initialPosition.y)
 //       }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if moveAmtX == 0 { return }
        
        var power: Int = abs(Int(moveAmtX) / Int(minimum_detect_distance))
        //the user has swiped past the designated distance, so assume that they want the page to scroll
        
        power = power < 0 ? 0 : power
        
        print("power \(power)")
        print("moveAmtX \(moveAmtX)")
        print("minimum_detect_distance \(minimum_detect_distance)")
        if moveAmtX < -minimum_detect_distance {
            swipeLeft(power: power)
        }
        else if moveAmtX > minimum_detect_distance {
            swipeRight(power: power)
        }
        
        //run(slideSound)
    }
    
    func checkForResetttingSlider() {

        let scrollDif: CGFloat = abs(imageContainer!.size.width - size.width) / 2.0

        print("\nscrollDif \(scrollDif)")
        print("imageContainer!.position.x \(imageContainer!.position.x)")
        print("imageContainer!.width \(imageContainer!.size.width)")
        
        //moving the slider right
        if imageContainer!.position.x > 0 {

            let move: SKAction = SKAction.moveTo(x: -squareSize / 2, duration: 0.2)
            move.timingMode = .easeOut
            imageContainer!.run(move)
        }

        //moving the slider left
        if imageContainer!.position.x < -(imageContainer!.size.width) {

            let move: SKAction = SKAction.moveTo(x: -(imageContainer!.size.width - squareSize / 2), duration: 0.2)
            move.timingMode = .easeOut
            imageContainer!.run(move)
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

