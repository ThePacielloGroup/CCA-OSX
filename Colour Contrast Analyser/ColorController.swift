//
//  ColorController.swift
//  Colour Contrast Analyser
//
//  Created by Cédric Trévisan on 26/01/2015.
//  Copyright (c) 2015 Cédric Trévisan. All rights reserved.
//

import Cocoa

class ColorController: NSViewController {    
    var color: NSColor!
    @IBOutlet weak var redSlider: NSSlider!
    @IBOutlet weak var greenSlider: NSSlider!
    @IBOutlet weak var blueSlider: NSSlider!
    @IBOutlet weak var colorPreview: NSTextFieldCell!
    @IBOutlet weak var hexField: NSTextField!
    @IBOutlet weak var rField: NSTextField!
    @IBOutlet weak var gField: NSTextField!
    @IBOutlet weak var bField: NSTextField!
    
    required init?(coder aDecoder: NSCoder) {
        self.color = NSColor()
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateHex()
        self.updateSliders()
        self.updateRGB()
        self.updatePreview()
    }
    
    @IBAction func sliderChanged(sender: NSSlider) {
        self.color = NSColor(redInt: redSlider.integerValue, greenInt: greenSlider.integerValue, blueInt: blueSlider.integerValue)
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
        self.color = NSColor(hexString: sender.stringValue)
        self.updatePreview()
        self.updateSliders()
        self.updateRGB()
        self.sendNotification()
    }

    @IBAction func rgbChanged(sender: NSTextField) {
        self.color = NSColor(redInt: rField.integerValue, greenInt: gField.integerValue, blueInt: bField.integerValue)
        self.updatePreview()
        self.updateHex()
        self.updateSliders()
        self.sendNotification()
    }
    
    func updatePreview() {
        self.colorPreview.backgroundColor = self.color
    }
    func updateHex() {
        self.hexField.stringValue = self.color.getHexString()
    }
    func updateSliders() {
        redSlider.integerValue = self.color.getRInt()
        greenSlider.integerValue = self.color.getGInt()
        blueSlider.integerValue = self.color.getBInt()
    }
    func updateRGB() {
        rField.integerValue = self.color.getRInt()
        gField.integerValue = self.color.getGInt()
        bField.integerValue = self.color.getBInt()
    }
    
    func sendNotification() {}
}

class ForegroundColorController: ColorController {
    override func viewDidLoad() {
        self.color = NSColor(red: 0, green: 0, blue: 0, alpha: 1.0)
        super.viewDidLoad()
    }
    
    override func sendNotification() {
        NSNotificationCenter.defaultCenter().postNotificationName("ForegroundColorChangedNotification", object: nil)

    }
}

class BackgroundColorController: ColorController {
    override func viewDidLoad() {
        self.color = NSColor(red: 1, green: 1, blue: 1, alpha: 1.0)
        super.viewDidLoad()
    }
    override func sendNotification() {
        NSNotificationCenter.defaultCenter().postNotificationName("BackgroundColorChangedNotification", object: nil)
        
    }
}