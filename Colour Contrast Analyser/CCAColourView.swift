//
//  CCAColourView.swift
//  Colour Contrast Analyser
//
//  Created by Cédric Trévisan on 08/02/2016.
//  Copyright © 2016 Cédric Trévisan. All rights reserved.
//

import Cocoa

class CCAColourView: NSView {

    var color: NSColor = NSColor(red: 0, green: 0, blue: 0, alpha: 1.0)

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
    }
    
    override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)
        // Drawing code here.
    }
    
    @IBAction func sliderChanged(sender: NSSlider) {
        self.color = NSColor(redInt: redSlider.integerValue, greenInt: greenSlider.integerValue, blueInt: blueSlider.integerValue)!
        self.updatePreview()
        self.updateHex()
        self.updateRGB()
        self.sendNotification()
    }
    
    @IBAction func colorPickerSelected(selectedColor: NSColor) {
        self.color = selectedColor
        self.updatePreview()
        self.updateHex()
        self.updateSliders()
        self.updateRGB()
        self.sendNotification()
    }
    
    @IBAction func hexChanged(sender: NSTextField) {
        if (sender.stringValue.characters.count == 7) {
            hexField.backgroundColor = NSColor.whiteColor()
            self.color = NSColor(hexString: sender.stringValue)!
            self.updatePreview()
            self.updateSliders()
            self.updateRGB()
            self.sendNotification()
        } else {
            hexField.backgroundColor = NSColor.redColor()
        }
    }
    
    @IBAction func rgbChanged(sender: NSTextField) {
        self.color = NSColor(redInt: rField.integerValue, greenInt: gField.integerValue, blueInt: bField.integerValue)!
        self.updatePreview()
        self.updateHex()
        self.updateSliders()
        self.sendNotification()
    }
    
    func sendNotification() {}
    
    func pickerColorSelected(notification: NSNotification){
        pickerController.close()
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "ColorSelectedNotification", object: nil)
        
        // Unhide the mouse
        CGDisplayShowCursor(CGMainDisplayID())
        colorPickerSelected(pickerController.color!)
    }
    
    @IBAction func colorPickerClicked(sender: NSButton) {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "pickerColorSelected:", name: "ColorSelectedNotification", object: nil)
        
        // Hide the mouse
        CGDisplayHideCursor(CGMainDisplayID())
        pickerController.showWindow(nil)
    }
    
    func updatePreview() {
        self.preview.layer?.backgroundColor = self.color.CGColor
    }
    func updateHex() {
        self.hexField.stringValue = self.color.getHexString()
        
    }
    func updateSliders() {
        self.redSlider.integerValue = self.color.getRInt()
        self.greenSlider.integerValue = self.color.getGInt()
        self.blueSlider.integerValue = self.color.getBInt()
    }
    func updateRGB() {
        self.rField.integerValue = self.color.getRInt()
        self.gField.integerValue = self.color.getGInt()
        self.bField.integerValue = self.color.getBInt()
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
        self.color = NSColor(red: 0, green: 0, blue: 0, alpha: 1.0)
        self.updateHex()
        self.updateSliders()
        self.updateRGB()
        self.updatePreview()
    }
    
    override func sendNotification() {
        let userInfo = ["color" : self.color]
        NSNotificationCenter.defaultCenter().postNotificationName("ForegroundColorChangedNotification", object: nil, userInfo: userInfo)
    }
}

class CCABackgroundColourView: CCAColourView {
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.title.stringValue = "Background Colour"
        self.color = NSColor(red: 1, green: 1, blue: 1, alpha: 1.0)
        self.updateHex()
        self.updateSliders()
        self.updateRGB()
        self.updatePreview()
    }
    
    override func sendNotification() {
        let userInfo = ["color" : self.color]
        NSNotificationCenter.defaultCenter().postNotificationName("BackgroundColorChangedNotification", object: nil, userInfo: userInfo)
    }
}