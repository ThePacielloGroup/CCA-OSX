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
    var contrastRatio: [Double] = [Double](repeating: 0.0, count: 5)
    var colourDiff: [Int] = [Int](repeating: 0, count: 5)
    var brightnessDiff: [Int] = [Int](repeating: 0, count: 5)
    var foregroundColor: [NSColor] = [NSColor]()
    var backgroundColor: [NSColor] = [NSColor]()
    
    let colourDeficiencyNone:ColourDeficiencyNone = ColourDeficiencyNone()
    let colourDeficiencyProtanopia:ColourDeficiencyProtanopia = ColourDeficiencyProtanopia()
    let colourDeficiencyDeuteranopia:ColourDeficiencyDeuteranopia = ColourDeficiencyDeuteranopia()
    let colourDeficiencyTritanopia:ColourDeficiencyTritanopia = ColourDeficiencyTritanopia()
    let colourDeficiencyColorBlindness:ColourDeficiencyColorBlindness = ColourDeficiencyColorBlindness()
    
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

        NotificationCenter.default.addObserver(self, selector: #selector(CCAColourDeficiencyController.updateForeground(_:)), name: NSNotification.Name(rawValue: "ForegroundColorChangedNotification"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(CCAColourDeficiencyController.updateBackground(_:)), name: NSNotification.Name(rawValue: "BackgroundColorChangedNotification"), object: nil)
    }

    @objc func updateForeground(_ notification: Notification) {
        let color = notification.userInfo!["color"] as! NSColor
        foregroundColor[0] = colourDeficiencyNone.convertColor(color)
        foregroundColor[1] = colourDeficiencyProtanopia.convertColor(color)
        foregroundColor[2] = colourDeficiencyDeuteranopia.convertColor(color)
        foregroundColor[3] = colourDeficiencyTritanopia.convertColor(color)
        foregroundColor[4] = colourDeficiencyColorBlindness.convertColor(color)
        updateContrastRatio()
        updateColourDiff()
        updateBrightnessDiff()
        self.tableView.reloadData()
    }

    @objc func updateBackground(_ notification: Notification) {
        let color = notification.userInfo!["color"] as! NSColor
        backgroundColor[0] = colourDeficiencyNone.convertColor(color)
        backgroundColor[1] = colourDeficiencyProtanopia.convertColor(color)
        backgroundColor[2] = colourDeficiencyDeuteranopia.convertColor(color)
        backgroundColor[3] = colourDeficiencyTritanopia.convertColor(color)
        backgroundColor[4] = colourDeficiencyColorBlindness.convertColor(color)
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
    
    func numberOfRows(in _tableView: NSTableView) -> Int {
        return deficiency.count
    }
    
    func tableView(_ _tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any?
    {
        var result = ""

        let columnIdentifier = tableColumn!.identifier
        if columnIdentifier.rawValue == "Deficiency" {
            result = deficiency[row]
        }
        if columnIdentifier.rawValue == "ContrastRatio" {
            if (!contrastRatio.isEmpty) {
                result = String(format:"%.1f:1", contrastRatio[row])
            }
        }
        if columnIdentifier.rawValue == "ColourBrightness" {
            if (!colourDiff.isEmpty) && (!brightnessDiff.isEmpty) {
                result = String(format:"%d / %d", colourDiff[row], brightnessDiff[row])
            }
        }
        return result
    }
    
    func tableView(_ tableView: NSTableView, willDisplayCell cell: Any, for tableColumn: NSTableColumn?, row: Int) {
        let fieldCell = cell as! NSTextFieldCell
        fieldCell.drawsBackground = true
        fieldCell.backgroundColor = backgroundColor[row]
        var color:NSColor = foregroundColor[row]
        // Fix for #3 : use almost black color
        if (color.isBlack()) {
            color = NSColor(red: 0.000001, green: 0, blue: 0, alpha: 1.0)
        }
        fieldCell.textColor = color
    }
}

