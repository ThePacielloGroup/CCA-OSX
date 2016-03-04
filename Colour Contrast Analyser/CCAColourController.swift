//
//  ColorController.swift
//  Colour Contrast Analyser
//
//  Created by Cédric Trévisan on 26/01/2015.
//  Copyright (c) 2015 Cédric Trévisan. All rights reserved.
//

import Cocoa

class CCAColourController: NSViewController, NSTextFieldDelegate {
    var color: NSColor = NSColor(red: 0, green: 0, blue: 0, alpha: 1.0)
    @IBOutlet weak var redSlider: NSSlider!
    @IBOutlet weak var greenSlider: NSSlider!
    @IBOutlet weak var blueSlider: NSSlider!
    @IBOutlet weak var colorPreview: NSTextFieldCell!
    @IBOutlet weak var hexField: NSTextField!
    @IBOutlet weak var rField: NSTextField!
    @IBOutlet weak var gField: NSTextField!
    @IBOutlet weak var bField: NSTextField!
    @IBOutlet weak var titleText: NSTextField!
    
    @IBOutlet weak var disclosureButton: NSButton!
    @IBOutlet weak var disclosureView: NSView!
    @IBOutlet weak var visibleView: NSView!
    @IBOutlet weak var headerView: NSView!
    
    var closingConstraint:NSLayoutConstraint?

    var isClosed = false
    
    var pickerController = CCAPickerController(windowNibName: "ColorPicker")
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init?(nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle!) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    override func viewDidLoad() {
        // White background for header
//        self.headerView.wantsLayer = true
//        self.headerView.layer?.backgroundColor = CGColorCreateGenericRGB(1, 1, 1, 1)
        
        // Display panel title
//        titleText.stringValue = title!
        
/*        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[disclosureView]|", options: NSLayoutFormatOptions(rawValue:0), metrics: nil, views: ["disclosureView": disclosureView]))

        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[visibleView][disclosureView]", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["visibleView":visibleView, "disclosureView":disclosureView]))

        // add an optional constraint (but with a priority stronger than a drag), that the disclosing view
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[disclosureView]-(0@600)-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["disclosureView":disclosureView]))
*/
        super.viewDidLoad()
        self.updateHex()
        self.updateSliders()
        self.updateRGB()
        self.updatePreview()
// ???       hexField.delegate = self
    }
    
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
    
    func updatePreview() {
        self.colorPreview.backgroundColor = self.color
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
    
    @IBAction func disclosureClicked(sender: NSButton) {
        if !isClosed {
            let distanceFromHeaderToBottom:CGFloat = NSMinY(self.view.bounds) - NSMinY(self.visibleView.frame);
            
            if self.closingConstraint == nil {
                // The closing constraint is going to tie the bottom of the header view to the bottom of the overall disclosure view.
                // Initially, it will be offset by the current distance, but we'll be animating it to 0.
                self.closingConstraint = NSLayoutConstraint(item:self.visibleView, attribute:NSLayoutAttribute.Bottom, relatedBy:NSLayoutRelation.Equal, toItem:self.view ,attribute:NSLayoutAttribute.Bottom, multiplier:1, constant:distanceFromHeaderToBottom)
            }
            self.closingConstraint!.constant = distanceFromHeaderToBottom
            self.view.addConstraint(self.closingConstraint!)
            
            NSAnimationContext.runAnimationGroup({ context in
                    context.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
                    // Animate the closing constraint to 0, causing the bottom of the header to be flush with the bottom of the overall disclosure view.
                self.closingConstraint!.animator().constant = 0
                self.disclosureButton.title = "Show RGB"
            }, completionHandler: {
                self.isClosed = true
            })
        } else {
            NSAnimationContext.runAnimationGroup({ context in
                context.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
                // Animate the constraint to fit the disclosed view again
                self.closingConstraint!.animator().constant -= self.disclosureView.frame.size.height
                self.disclosureButton.title = "Hide RGB"
                }, completionHandler: {
                    self.view.removeConstraint(self.closingConstraint!)
                    self.isClosed = false
            })
        }
    }
}


class CCAForegroundColourController: CCAColourController {
    override func viewDidLoad() {
        self.color = NSColor(red: 0, green: 0, blue: 0, alpha: 1.0)
        super.viewDidLoad()
    }
    
    override func sendNotification() {
        let userInfo = ["color" : self.color]
        NSNotificationCenter.defaultCenter().postNotificationName("ForegroundColorChangedNotification", object: nil, userInfo: userInfo)
    }
}

class CCABackgroundColourController: CCAColourController {
    override func viewDidLoad() {
        self.color = NSColor(red: 1, green: 1, blue: 1, alpha: 1.0)
        super.viewDidLoad()
    }
    override func sendNotification() {
        let userInfo = ["color" : self.color]
        NSNotificationCenter.defaultCenter().postNotificationName("BackgroundColorChangedNotification", object: nil, userInfo: userInfo)
    }
}