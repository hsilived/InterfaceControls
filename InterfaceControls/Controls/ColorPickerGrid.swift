//
//  ColorPickerGrid.swift
//  TextInputBox
//
//  Created by DeviL on 2015-05-20.
//  Copyright (c) 2015 com.orangethinkbox. All rights reserved.
//
import SpriteKit

struct ColorPickerGridCount {
    var cols: Int = 0
    var rows: Int = 0
}

protocol ColorPickerGridDataSource: NSObjectProtocol {
    
    func numberOfColors(colorPickerGrid: ColorPickerGrid) -> Int
    func colorPickerGrid(colorPickerGrid: ColorPickerGrid, selectionAtIndex: Int) -> String
}

protocol ColorPickerGridDelegate: NSObjectProtocol {
    func colorPickerGridDidStartEditing(colorPickerGrid: ColorPickerGrid)
}

class ColorPickerGrid: SKSpriteNode {

    //weak var dataSource: ColorPickerGridDataSource!
    weak var delegate: ColorPickerGridDelegate!

    private var colorButtons = [ColorSelectionButton]()
    private var colCount: Int = 0
    private var rowCount: Int = 0
    private var squareSize: Int = 0
    private var squarePadding: Int = 0
    private var colorsCount: Int = 0
    
    var selectedColor: SKColor!
    
    //MARK:- Custom properties
    
    weak var dataSource: ColorPickerGridDataSource! {
        
        didSet {
            self.createColorGrid()
        }
    }
    
    var initialColor = "" {
        
        didSet {
            
            for node: SKNode in self.children {
                
                if (node is ColorSelectionButton) {
                    
                    if initialColor == (node as! ColorSelectionButton).colorString {
                        if let button = node as? ColorSelectionButton {
                            button.isHighlighted = true
                            self.selectColor(button)
                        }
                    }
                }
            }
        }
    }
    
    // MARK: Initialization

    init(gridCount: ColorPickerGridCount, squareSize: Int) {
        
        squarePadding = 5
        colCount = gridCount.cols
        rowCount = gridCount.rows
        
        let width: Int = colCount * squareSize + (colCount - 1) * squarePadding
        let height: Int = rowCount * squareSize + (rowCount - 1) * squarePadding
        super.init(texture: nil, color: .clear, size: CGSize(width: CGFloat(width), height: CGFloat(height)))
        
        self.squareSize = squareSize
        
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        
        setup()
    }
    
    func setup() {
        
        self.anchorPoint = CGPoint.zero
        self.zPosition = 1
    }
    
    func colorsCounter() -> Int {
        
        if colorsCount > 0 {
            return colorsCount
        }
        
        colorsCount = 1
        
        if (self.dataSource != nil) {
            colorsCount = self.dataSource.numberOfColors(colorPickerGrid: self)
        }
        
        return colorsCount
    }

    func createColorGrid() {
        
        let size = CGSize(width: CGFloat(squareSize), height: CGFloat(squareSize))
        
        for row in 0..<rowCount {
            
            for col in 0..<colCount {
                
                let colorButton = ColorSelectionButton(color: self.dataSource.colorPickerGrid(colorPickerGrid: self, selectionAtIndex: col + row * colCount), size: size)
                colorButton.delegate = self
                colorButton.position = CGPoint(x: CGFloat(squareSize / 2 + ((squareSize + squarePadding) * col)), y: CGFloat(squareSize / 2 + ((squareSize + squarePadding) * row)))
                self.addChild(colorButton)
                
                colorButtons.append(colorButton)
            }
        }
    }
    
    func resetSelectedColor() {
        selectedColor = nil
        unhighlightAllButtons()
    }
    
    func unhighlightAllButtons() {
        
        for colorButton in colorButtons {
            colorButton.isHighlighted = false
        }
    }
}

extension ColorPickerGrid: ColorSelectionButtonDelegate {
    
    func unhighlightAllButtons(colorSelectionButton: ColorSelectionButton) {
        
        for node in (colorSelectionButton.parent?.children)! {
            
            if (node is ColorSelectionButton) {
                (node as? ColorSelectionButton)?.isHighlighted = false
            }
        }
    }
    
    func selectColor(_ colorSelectionButton: ColorSelectionButton) {
        
        self.selectedColor = colorSelectionButton.color
        self.delegate.colorPickerGridDidStartEditing(colorPickerGrid: self)
    }
}
