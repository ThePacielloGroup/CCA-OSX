//
//  CCAColourDeficiencyController.swift
//  Colour Contrast Analyser
//
//  Created by Cédric Trévisan on 19/02/2015.
//  Copyright (c) 2015 Cédric Trévisan. All rights reserved.
//

import Cocoa

class CCAColourDeficiencyController: NSTabViewController, NSTableViewDelegate, NSTableViewDataSource {
    var deficiency: [String] = [NSLocalizedString("normal", comment:"Normal"),
        NSLocalizedString("protanopia", comment:"Protanopia"),
        NSLocalizedString("deuteranopia", comment:"Deuteranopia"),
        NSLocalizedString("tritanopia", comment:"Tritanopia"),
        NSLocalizedString("color_blindness", comment:"Color blindness")]
    var contrastRatio: [Double] = [Double](count: 5, repeatedValue: 0.0)
    var colourDiff: [Int] = [Int](count: 5, repeatedValue: 0)
    var brightnessDiff: [Int] = [Int](count: 5, repeatedValue: 0)
    var foregroundColor: [NSColor] = [NSColor]()
    var backgroundColor: [NSColor] = [NSColor]()
    
    let colourDeficiencyNone:ColourDeficiencyNone = ColourDeficiencyNone()
    let colourDeficiencyProtanopia:ColourDeficiencyProtanopia = ColourDeficiencyProtanopia()
    let colourDeficiencyDeuteranopia:ColourDeficiencyDeuteranopia = ColourDeficiencyDeuteranopia()
    let colourDeficiencyTritanopia:ColourDeficiencyTritanopia = ColourDeficiencyTritanopia()
    let colourDeficiencyColorBlindness:ColourDeficiencyColorBlindness = ColourDeficiencyColorBlindness()
    
    @IBOutlet weak var foreground: ForegroundColorController!
    @IBOutlet weak var background: BackgroundColorController!
    @IBOutlet weak var tableView: NSTableView!
    
    required init?(coder: NSCoder) {
        super.init(coder:coder)
        let white = NSColor(red: 1, green: 1, blue: 1, alpha: 1.0)
        let black = NSColor(red: 0, green: 0, blue: 0, alpha: 1.0)
        foregroundColor.append(colourDeficiencyNone.convertColor(black))
        foregroundColor.append(colourDeficiencyProtanopia.convertColor(black))
        foregroundColor.append(colourDeficiencyDeuteranopia.convertColor(black))
        foregroundColor.append(colourDeficiencyTritanopia.convertColor(black))
        foregroundColor.append(colourDeficiencyColorBlindness.convertColor(black))
        backgroundColor.append(colourDeficiencyNone.convertColor(white))
        backgroundColor.append(colourDeficiencyProtanopia.convertColor(white))
        backgroundColor.append(colourDeficiencyDeuteranopia.convertColor(white))
        backgroundColor.append(colourDeficiencyTritanopia.convertColor(white))
        backgroundColor.append(colourDeficiencyColorBlindness.convertColor(white))

        updateContrastRatio()
        updateColourDiff()
        updateBrightnessDiff()

        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateForeground:", name: "ForegroundColorChangedNotification", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateBackground:", name: "BackgroundColorChangedNotification", object: nil)
    }

    func updateForeground(notification: NSNotification) {
        foregroundColor[0] = colourDeficiencyNone.convertColor(foreground.color)
        foregroundColor[1] = colourDeficiencyProtanopia.convertColor(foreground.color)
        foregroundColor[2] = colourDeficiencyDeuteranopia.convertColor(foreground.color)
        foregroundColor[3] = colourDeficiencyTritanopia.convertColor(foreground.color)
        foregroundColor[4] = colourDeficiencyColorBlindness.convertColor(foreground.color)
        updateContrastRatio()
        updateColourDiff()
        updateBrightnessDiff()
        self.tableView.reloadData()
    }

    func updateBackground(notification: NSNotification) {
        backgroundColor[0] = colourDeficiencyNone.convertColor(background.color)
        backgroundColor[1] = colourDeficiencyProtanopia.convertColor(background.color)
        backgroundColor[2] = colourDeficiencyDeuteranopia.convertColor(background.color)
        backgroundColor[3] = colourDeficiencyTritanopia.convertColor(background.color)
        backgroundColor[4] = colourDeficiencyColorBlindness.convertColor(background.color)
        updateContrastRatio()
        updateColourDiff()
        updateBrightnessDiff()
        self.tableView.reloadData()
    }
    
    func updateContrastRatio() {
        contrastRatio[0] = Luminosity.getResult(foregroundColor[0], bColor: backgroundColor[0])
        contrastRatio[1] = Luminosity.getResult(foregroundColor[1], bColor: backgroundColor[1])
        contrastRatio[2] = Luminosity.getResult(foregroundColor[2], bColor: backgroundColor[2])
        contrastRatio[3] = Luminosity.getResult(foregroundColor[3], bColor: backgroundColor[3])
        contrastRatio[4] = Luminosity.getResult(foregroundColor[4], bColor: backgroundColor[4])
    }
    
    func updateColourDiff() {
        colourDiff[0] = ColourBrightnessDifference.getColourDifference(foregroundColor[0], bc: backgroundColor[0])
        colourDiff[1] = ColourBrightnessDifference.getColourDifference(foregroundColor[1], bc: backgroundColor[1])
        colourDiff[2] = ColourBrightnessDifference.getColourDifference(foregroundColor[2], bc: backgroundColor[2])
        colourDiff[3] = ColourBrightnessDifference.getColourDifference(foregroundColor[3], bc: backgroundColor[3])
        colourDiff[4] = ColourBrightnessDifference.getColourDifference(foregroundColor[4], bc: backgroundColor[4])
    }
    
    func updateBrightnessDiff() {
        brightnessDiff[0] = ColourBrightnessDifference.getBrightnessDifference(foregroundColor[0], bc: backgroundColor[0])
        brightnessDiff[1] = ColourBrightnessDifference.getBrightnessDifference(foregroundColor[1], bc: backgroundColor[1])
        brightnessDiff[2] = ColourBrightnessDifference.getBrightnessDifference(foregroundColor[2], bc: backgroundColor[2])
        brightnessDiff[3] = ColourBrightnessDifference.getBrightnessDifference(foregroundColor[3], bc: backgroundColor[3])
        brightnessDiff[4] = ColourBrightnessDifference.getBrightnessDifference(foregroundColor[4], bc: backgroundColor[4])
    }
    
    func numberOfRowsInTableView(aTableView: NSTableView!) -> Int {
        return deficiency.count
    }
    
    func tableView(tableView: NSTableView!, objectValueForTableColumn tableColumn: NSTableColumn!, row: Int) -> AnyObject!
    {
        var result = ""

        var columnIdentifier = tableColumn.identifier
        if columnIdentifier == "Deficiency" {
            result = deficiency[row]
        }
        if columnIdentifier == "ContrastRatio" {
            if (!contrastRatio.isEmpty) {
                result = String(format:"%.2f:1", contrastRatio[row])
            }
        }
        if columnIdentifier == "ColourBrightness" {
            if (!colourDiff.isEmpty) && (!brightnessDiff.isEmpty) {
                result = String(format:"%d / %d", colourDiff[row], brightnessDiff[row])
            }
        }
        return result
    }
    
    func tableView(tableView: NSTableView, willDisplayCell cell: AnyObject, forTableColumn tableColumn: NSTableColumn?, row: Int) {
        var fieldCell = cell as NSTextFieldCell
        fieldCell.drawsBackground = true
        fieldCell.backgroundColor = backgroundColor[row]
        fieldCell.textColor = foregroundColor[row]
    }
}

