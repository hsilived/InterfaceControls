//
//  ColorPicker.swift
//  BusDriver
//
//  Created by DeviL on 2016-06-19.
//  Copyright © 2016 Orange Think Box. All rights reserved.
//

import Foundation
import SpriteKit
import GameController

struct MultiPosition {
    var col = 0
    var row = 0
}

protocol ColorPickerDelegate: NSObject {
 
    func colorPickerDidStartEditing(colorPicker: ColorPicker)
    func selected(color: SKColor)
    func hideColorPicker()
}

class ColorPicker: SKSpriteNode {

    weak var delegate: ColorPickerDelegate!

    private var colorCells = [[ColorSelectionButton]]()
    private var colorsContainer: SKSpriteNode!
    private var thumbnail: SKSpriteNode!
    private var background: SKSpriteNode!
    private var colorpickerButton: ColorPickerButton!
    
    private var colorSize = CGSize.zero
    private var gridCount = CGSize.zero
    private var xPadding: CGFloat = 0
    private var yPadding: CGFloat = 0
    private var buttonWidth: CGFloat = 0
    private var colorGridWidth: CGFloat = 0
    private var colorGridHeight: CGFloat = 0
    private var colorCount: CGFloat = 0
    private var colors: [[SKColor]] = [[SKColor]]()
    private var lastColorPickerIndex = MultiPosition(col: 0, row: 0)
    
    var selectedColor: SKColor!
    var popupLocation = CGPoint.zero
    
    //custom properties
    
    var initialColor = "" {
        
        didSet {
            
            for colorSelectionButton in colorCells.joined() {
 
                if initialColor == colorSelectionButton.colorString {
                    colorSelectionButton.isHighlighted = true
                    self.selectColor(colorSelectionButton)
                }
            }
        }
    }
    
    var focusedCell: ColorSelectionButton? {
        
        willSet {
            
            if focusedCell != nil {
                focusedCell!.isHighlighted = false
            }
        }
        didSet {
            
            if focusedCell != nil {
                focusedCell!.isHighlighted = true
            }
        }
    }
    
    //inititalizer
    
    init(outputSize: CGSize, popupSize: CGSize, color: SKColor) {
        
        super.init(texture: nil, color: color, size: popupSize)

        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        
        setup()
    }

    func setup() {
        
        isPaused = false
        isUserInteractionEnabled = true
        
        xPadding = 5
        yPadding = 3
        gridCount = CGSize(width: 10, height: 15)
        
        //var width = (self.size.width - (xPadding * 2)) / ( gridCount.width) - xPadding
        //width = isIpad ? width - 15 : width
        //colorSize = CGSize(width: width, height: width)
        buttonWidth = 100
        
        createThumbnail()
        
        createPickerButton()
        
        loadColors()
        
        createColorsContainer()
        
        createColorsGrid()
    }
    
    func createThumbnail() {
        
        let insetX: CGFloat = 9
        let insetY: CGFloat = 9

        thumbnail = SKSpriteNode(imageNamed: "textbox")
        thumbnail.centerRect = CGRect(x: insetX / thumbnail.size.width, y: insetY / thumbnail.size.height, width: (thumbnail.size.width - insetX * 2) / thumbnail.size.width, height: (thumbnail.size.height - insetY * 2) / thumbnail.size.height)
        thumbnail.xScale = size.width / thumbnail.size.width
        thumbnail.yScale = size.height / thumbnail.size.height
        thumbnail.colorBlendFactor = 1.0
        thumbnail.color = .white
        addChild(thumbnail)
    }
    
    func createBackground(scene: SKScene) {
        
        background = SKSpriteNode(color: .white, size: scene.size)
        let pos = self.convert(self.convert(CGPoint.zero, from: scene), to: self)
        background.position = pos
        background.zPosition = 100
        background.alpha = 0.6
        background.isHidden = true
        addChild(background)
    }
    
    func createPickerButton() {
        
        let colorPickerButton = ColorPickerButton(size: CGSize(width: self.size.height, height: self.size.height))
        colorPickerButton.delegate = self
        colorPickerButton.position = CGPoint(x: self.size.width / 2 + colorPickerButton.size.width / 2, y: 0)
        colorPickerButton.zPosition = 10
        self.addChild(colorPickerButton)
    }
    
    func createColorsContainer() {
            
        colorGridWidth = gridCount.width * buttonWidth + ((gridCount.width + 1) * xPadding)
        colorGridHeight = gridCount.height * buttonWidth + ((gridCount.height + 1) * yPadding)
        let colorGridSize = CGSize(width: colorGridWidth, height: colorGridHeight)

        colorsContainer = SKSpriteNode(color: .white, size: colorGridSize)
        colorsContainer.position = popupLocation
        colorsContainer.isHidden = true
        colorsContainer.zPosition = 1000
        addChild(colorsContainer)
    }
    
    func loadColors() {
        
        colors.append(createColors(startColor: SKColor.white, count: 10, ignoreSat: true))//greytones
        colors.append(createColors(startColor: SKColorWithRGB(r: 204, g: 171, b: 122), count: 10, ignoreSat: false))//coffee
        colors.append(createColors(startColor: SKColor.carrot(), count: 10, ignoreSat: false))//deep orange
        colors.append(createColors(startColor: SKColor.orange(), count: 10, ignoreSat: false))//light orange
        colors.append(createColors(startColor: SKColor.sunFlower(), count: 10, ignoreSat: false))//goldy yellow
        colors.append(createColors(startColor: SKColorWithRGB(r: 155, g: 197, b: 61), count: 10, ignoreSat: false))//lime green
        colors.append(createColors(startColor: SKColorWithRGB(r: 135, g: 211, b: 124), count: 10, ignoreSat: false))//forest green
        colors.append(createColors(startColor: SKColor.emerald(), count: 10, ignoreSat: false))//light green
        colors.append(createColors(startColor: SKColor.turquoise(), count: 10, ignoreSat: false))//bluey green
        colors.append(createColors(startColor: SKColor.peterRiver(), count: 10, ignoreSat: false))//light blue
        colors.append(createColors(startColor: SKColorWithRGB(r: 79, g: 92, b: 156), count: 10, ignoreSat: false))//dark blue
        colors.append(createColors(startColor: SKColor.amethyst(), count: 10, ignoreSat: false))//purple
        colors.append(createColors(startColor: SKColorWithRGB(r: 245, g: 121, b: 193), count: 10, ignoreSat: false))//pink
        colors.append(createColors(startColor: SKColorWithRGB(r: 246, g: 36, b: 89), count: 10, ignoreSat: false))//red
        colors.append(createColors(startColor: SKColorWithRGB(r: 150, g: 40, b: 27), count: 10, ignoreSat: false))//maroon
    }

    func createColors(startColor: SKColor, count: CGFloat, ignoreSat: Bool) -> [SKColor] {
        
        var colors = [SKColor]()
        
        var startHue: CGFloat = 0
        var startSat: CGFloat = 0
        var startBright: CGFloat = 0
        var startAlpha: CGFloat = 0
        
        startColor.getHue(&startHue, saturation: &startSat, brightness: &startBright, alpha: &startAlpha)
        var satIncrement: CGFloat = 18 / 100//(endSat - startSat) / count
        var brightIncrement: CGFloat = 17 / 100
        
        if startSat < 100 {
            satIncrement = startSat / 4
        }

        var sat: CGFloat = 10 / 100//startSat - (count / 2 * satIncrement)
        var bright: CGFloat = 100 / 100//startBright - (count / 2 * brightIncrement)
        
        if ignoreSat {
            brightIncrement = 9.5 / 100
            sat = startSat
        }
        
        var x: CGFloat = 0
        
        if !ignoreSat {
            repeat {
                
                let color: SKColor = SKColor(hue: startHue, saturation: sat, brightness: bright, alpha: alpha)
                colors.append(color)
                //hue += hueIncrement
                sat += satIncrement
//                print ("sat \(sat)")
                //bright += brightIncrement
                //alpha += alphaIncrement
                x += 1
            } while x < count / 2
        }
        
        var amount: CGFloat = 2
        if ignoreSat {
            amount = 1
        }
        
        x = 0

        repeat {
            
            let color = SKColor(hue: startHue, saturation: sat, brightness: bright, alpha: alpha)
            colors.append(color)
            bright -= brightIncrement
            x += 1
        } while x < count / amount
        
        return colors
    }
    
    func setFocus() {
        //gcControllerHelper.delegate = self
        
        if focusedCell == nil {
            focusedCell = colorCells[lastColorPickerIndex.col][lastColorPickerIndex.row]
        }
    }
        
    func createColorsGrid() {
        
        var index = 0
        
        //remove all of the previous colors
        colorCells.removeAll()
        
        let startX = colorsContainer.frame.minX + xPadding + buttonWidth / 2 //-colorGridWidth / 2 + (buttonWidth + yPadding) + xPadding + colorSize.width / 2
        let startY = colorsContainer.size.height / 2 - yPadding - buttonWidth / 2
        
        for row in 0..<Int(gridCount.height) {
            
            var colOfComponents = [ColorSelectionButton]()
            
            for col in 0..<Int(gridCount.width) {
                
                let colorButton = ColorSelectionButton(color: colors[row][col], size: CGSize(width: buttonWidth, height: buttonWidth))
                colorButton.delegate = self
                colorButton.multiPos = MultiPosition(col: col, row: row)
                colorButton.zPosition = 10
                colorButton.position = CGPoint(x: startX + ((xPadding + buttonWidth) * CGFloat(col)), y: startY - ((yPadding + buttonWidth) * CGFloat(row)))
                colorsContainer.addChild(colorButton)
                                
                colOfComponents.append(colorButton)
                
                index += 1
            }
            
            colorCells.append(colOfComponents)
        }
    }
    
    //MARK: - Move functions
    
    func getIndexFromPosition(row: Int, col: Int) -> Int {
        
        return row * Int(gridCount.width) + col;
    }
    
    func validatePosition(row: Int, col: Int) -> ColorSelectionButton {
        
        let index = getIndexFromPosition(row: row, col: col)
        
        if index >= Int(colorCount) {
            
            for tempRow in (0...row).reversed() {
                
                //TODO: should this be col count not actual col???????
                for tempCol in (0...col).reversed() {
                    
                    if isValidPosition(row: tempRow, col: tempCol) {
                        lastColorPickerIndex = MultiPosition(col: tempCol, row: tempRow)
                        return colorCells[tempCol][tempRow]
                    }
                }
            }
        }
        
        lastColorPickerIndex = MultiPosition(col: col, row: row)
        return colorCells[col][row]
    }

    func isValidPosition( row: Int, col: Int) -> Bool {
        
        let index = getIndexFromPosition(row: row, col: col)
        
        return index < Int(colorCount)
    }
    
    func displayColorPicker() {
        
        background.isHidden = false
        colorsContainer.position = popupLocation
        colorsContainer.isHidden = false
    }
    
    func hideColorPicker() {
        background.isHidden = true
        colorsContainer.isHidden = true
    }
    
    func resetSelectedColor() {
        
        let lastButton = colorCells[lastColorPickerIndex.row][lastColorPickerIndex.col]
        lastButton.isHighlighted = false
        lastColorPickerIndex = MultiPosition(col: 0, row: 0)
        self.selectedColor = nil
        thumbnail.color = .white
    }
    
    //MARK: Touches Methods
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent!)  {
        
        if let touch = touches.first as UITouch? {
            
            let touchLocation = touch.location(in: self)
            
            if thumbnail.frame.contains(touchLocation) {
                self.delegate?.colorPickerDidStartEditing(colorPicker: self)
                displayColorPicker()
                return
            }
            
            if background.frame.contains(touchLocation) {
                hideColorPicker()
            }
        }
    }
}

//MARK:- ColorSelectionButtonDelegate

extension ColorPicker: ColorSelectionButtonDelegate {
    
    func unhighlightAllButtons(colorSelectionButton: ColorSelectionButton) { }
    
    func selectColor(_ colorSelectionButton: ColorSelectionButton) {
        
        let lastButton = colorCells[lastColorPickerIndex.row][lastColorPickerIndex.col]
        print("lastColorPickerIndex \(lastColorPickerIndex)")
        lastColorPickerIndex = colorSelectionButton.multiPos!
        print("lastColorPickerIndex \(lastColorPickerIndex)")
        self.selectedColor = colorSelectionButton.color
        
        lastButton.isHighlighted = false
        
        thumbnail.color = selectedColor
        self.delegate?.hideColorPicker()
      
        hideColorPicker()
        
        self.delegate?.selected(color: selectedColor)
    }
}

//MARK:- ColorPickerButtonDelegate

extension ColorPicker: ColorPickerButtonDelegate {
    
    func colorPickerButtonPushed(_ colorPickerButton: ColorPickerButton) {
        self.delegate?.colorPickerDidStartEditing(colorPicker: self)
        displayColorPicker()
    }
}
    
   

