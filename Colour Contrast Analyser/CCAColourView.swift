//
//  CCAColourView.swift
//  Colour Contrast Analyser
//
//  Created by Cédric Trévisan on 08/02/2016.
//  Copyright © 2016 Cédric Trévisan. All rights reserved.
//

import Cocoa

class CCAColourView: NSView {

    var color: CCAColor!

    @IBOutlet var view: NSView!
    @IBOutlet weak var title: NSTextField!
    @IBOutlet weak var hexField: NSTextField!
    @IBOutlet weak var redSlider: NSSlider!
    @IBOutlet weak var greenSlider: NSSlider!
    @IBOutlet weak var blueSlider: NSSlider!
    @IBOutlet weak var rField: NSTextField!
    @IBOutlet weak var gField: NSTextField!
    @IBOutlet weak var bField: NSTextField!
    
    @IBOutlet var preview: NSView!
    @IBOutlet weak var header: NSView!

    var pickerController = CCAPickerController(windowNibName: "ColorPicker")
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
    }

    // init for Ibuilder
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        NSBundle.mainBundle().loadNibNamed("ColourView", owner: self, topLevelObjects: nil)
        
        // Makes XIB View size same
        self.view.frame = self.bounds
        // add XIB's view to Custom NSView Subclass
        self.addSubview(self.view)
        self.preview.wantsLayer = true
        self.header.wantsLayer = true
        self.header.layer?.backgroundColor = NSColor.whiteColor().CGColor
    }
    
    @IBAction func sliderChanged(sender: NSSlider) {
        self.color.update(NSColor(redInt: redSlider.integerValue, greenInt: greenSlider.integerValue, blueInt: blueSlider.integerValue)!)
        self.updatePreview()
        self.updateHex()
        self.updateRGB()
    }
    
    @IBAction func colorPickerSelected(selectedColor: NSColor) {
        self.color.update(selectedColor)
        self.updatePreview()
        self.updateHex()
        self.updateSliders()
        self.updateRGB()
    }
    
    @IBAction func hexChanged(sender: NSTextField) {
        if (validateHex(sender.stringValue)) {
            hexField.backgroundColor = NSColor.whiteColor()
            self.color.update(NSColor(hexString: sender.stringValue)!)
            self.updatePreview()
            self.updateSliders()
            self.updateRGB()
        } else {
            hexField.backgroundColor = NSColor.redColor()
        }
    }
    
    @IBAction func rgbChanged(sender: NSTextField) {
        self.color.update(NSColor(redInt: rField.integerValue, greenInt: gField.integerValue, blueInt: bField.integerValue)!)
        self.updatePreview()
        self.updateHex()
        self.updateSliders()
    }
    
    func pickerColorSelected(notification: NSNotification){
        pickerController.close()
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "ColorSelectedNotification", object: nil)
        
        colorPickerSelected(pickerController.color!)
    }
    
    @IBAction func colorPickerClicked(sender: NSButton) {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "pickerColorSelected:", name: "ColorSelectedNotification", object: nil)
        pickerController.showWindow(nil)
    }
    
    func updatePreview() {
        self.preview.layer?.backgroundColor = self.color.value.CGColor
    }
    func updateHex() {
        self.hexField.stringValue = self.color.value.getHexString()
        
    }
    func updateSliders() {
        self.redSlider.integerValue = self.color.value.getRInt()
        self.greenSlider.integerValue = self.color.value.getGInt()
        self.blueSlider.integerValue = self.color.value.getBInt()
    }
    func updateRGB() {
        self.rField.integerValue = self.color.value.getRInt()
        self.gField.integerValue = self.color.value.getGInt()
        self.bField.integerValue = self.color.value.getBInt()
    }
    
    func validateHex(value: String) -> Bool {
        let regexp = try! NSRegularExpression(pattern: "^#?([0-9A-Fa-f]{6})|([0-9A-Fa-f]{3})$", options: NSRegularExpressionOptions.CaseInsensitive)
        let valueRange = NSRange(location:0, length: value.characters.count )
        let result = regexp.rangeOfFirstMatchInString(value, options: .Anchored, range: valueRange)
        if (result.location == NSNotFound) {
            // regexp validation failed
            return false
        }
        else {
            return true
        }
    }
    
    /*
    override func controlTextDidChange(obj: NSNotification) {
        var correctedString:String = hexField.stringValue
        //Trims non-numerical characters
        let regex = try! NSRegularExpression(pattern:"[^0-9AaBbCcDdEeFf]", options: .CaseInsensitive)
        
        correctedString = regex.stringByReplacingMatchesInString(correctedString, options:[.Anchored], range:NSMakeRange(0, correctedString.characters.count), withTemplate:"")
        // Length 6
        if correctedString.characters.count > 6 {
            correctedString = correctedString.substringToIndex(correctedString.startIndex.advancedBy(6))
        }
        correctedString = correctedString.uppercaseString
        hexField.stringValue = "#" + correctedString
    }*/
}

class CCAForegroundColourView: CCAColourView {
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.title.stringValue = "Foreground Colour"
        self.color = CCAColorForeground.sharedInstance
        self.updateHex()
        self.updateSliders()
        self.updateRGB()
        self.updatePreview()
    }
}

class CCABackgroundColourView: CCAColourView {
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.title.stringValue = "Background Colour"
        self.color = CCAColorBackground.sharedInstance
        self.updateHex()
        self.updateSliders()
        self.updateRGB()
        self.updatePreview()
    }
}