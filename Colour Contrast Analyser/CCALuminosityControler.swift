//
//  CCALuminosityControler.swift
//  Colour Contrast Analyser
//
//  Created by Cédric Trévisan on 19/02/2015.
//  Copyright (c) 2015 Cédric Trévisan. All rights reserved.
//

import Cocoa
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}


class CCALuminosityControler: NSViewController {
    
    @IBOutlet weak var ratioText: NSTextField!
    @IBOutlet weak var textAA: CCALuminosityLevelField!
    @IBOutlet weak var textAAA: CCALuminosityLevelField!
    @IBOutlet weak var largeTextAA: CCALuminosityLevelField!
    @IBOutlet weak var largeTextAAA: CCALuminosityLevelField!

    var fColor: NSColor = NSColor(red: 0, green: 0, blue: 0, alpha: 1.0)
    var bColor: NSColor = NSColor(red: 1, green: 1, blue: 1, alpha: 1.0)
    
    var luminosityValue:Double?
    var contrastRatioString:String?
    var passAA:Bool?
    var passAAA:Bool?
    var passAALarge:Bool?
    var passAAALarge:Bool?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        textAA.level = "AA"
        textAAA.level = "AAA"
        largeTextAA.level = "AA"
        largeTextAAA.level = "AAA"

        self.updateResults()
        NotificationCenter.default.addObserver(self, selector: #selector(CCALuminosityControler.updateForeground(_:)), name: NSNotification.Name(rawValue: "ForegroundColorChangedNotification"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(CCALuminosityControler.updateBackground(_:)), name: NSNotification.Name(rawValue: "BackgroundColorChangedNotification"), object: nil)
    }
    
    func updateResults() {
        //    if ((2.95 <= eRaw) and (3 > eRaw)) or ((4.45 <= eRaw) and (4.5 > eRaw)) then
        luminosityValue = Luminosity.getResult(self.fColor, bColor:self.bColor)
        let roundedValue = round(luminosityValue!*1000)/1000
        contrastRatioString = String(format:"%.3f:1", roundedValue)
        if ((luminosityValue! >= 6.95 && luminosityValue! < 7) || (luminosityValue! >= 4.45 && luminosityValue! < 4.5) || (luminosityValue! >= 2.95 && luminosityValue! < 3)) {
            ratioText.stringValue = String(format:NSLocalizedString("contrast_ratio_below", comment:"")) + String(format:"%.1f:1 (%.3f:1)", luminosityValue!, roundedValue)
        } else {
            ratioText.stringValue = String(format:NSLocalizedString("contrast_ratio", comment:"")) + String(format:"%.1f:1", luminosityValue!)
        }

        passAA = true
        passAAA = true
        passAALarge = true
        passAAALarge = true
        if luminosityValue < 7 {
            passAAA = false
        }
        if luminosityValue < 4.5 {
            passAA = false
            passAAALarge = false
        }
        if luminosityValue < 3 {
            passAALarge = false
        }
        textAA.pass = passAA
        textAAA.pass = passAAA
        largeTextAA.pass = passAALarge
        largeTextAAA.pass = passAAALarge
    }
    @objc func updateForeground(_ notification: Notification) {
        self.fColor = notification.userInfo!["color"] as! NSColor
        self.updateResults()
        
        var color:NSColor = self.fColor
        // Fix for #3 : use almost black color
        if (color.isBlack()) {
            color = NSColor(red: 0.000001, green: 0, blue: 0, alpha: 1.0)
        }
        textAA.textColor = color
        textAAA.textColor = color
        largeTextAA.textColor = color
        largeTextAAA.textColor = color
    }
    @objc func updateBackground(_ notification: Notification) {
        self.bColor = notification.userInfo!["color"] as! NSColor
        self.updateResults()
        textAA.backgroundColor = self.bColor
        textAAA.backgroundColor = self.bColor
        largeTextAA.backgroundColor = self.bColor
        largeTextAAA.backgroundColor = self.bColor
    }
}
