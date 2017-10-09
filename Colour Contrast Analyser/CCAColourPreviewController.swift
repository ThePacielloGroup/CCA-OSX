//
//  CCAColourPreviewController.swift
//  Colour Contrast Analyser
//
//  Created by Cédric Trévisan on 08/02/2016.
//  Copyright © 2016 Cédric Trévisan. All rights reserved.
//

import Cocoa

class CCAColourPreviewController: NSView, NSTextFieldDelegate {

    var color: CCAColour!

    @IBOutlet var view: NSView!
    @IBOutlet weak var hexField: NSTextField!
    @IBOutlet weak var warning: NSImageView!
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
    }

    // init for Ibuilder
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        Bundle.main.loadNibNamed(NSNib.Name(rawValue: "ColourPreviewView"), owner: self, topLevelObjects: nil)
        
        hexField.delegate = self
        
        // Makes XIB View size same
        self.view.frame = self.bounds
        // add XIB's view to Custom NSView Subclass
        self.addSubview(self.view)
        self.view.wantsLayer = true
        self.view.translatesAutoresizingMaskIntoConstraints = false
        
        // these are 10.11-only APIs, but you can use the visual format language or any other autolayout APIs
        self.view.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        self.view.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        self.view.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        self.view.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
    }
    
    @objc func update(_ notification: Notification) {
        self.updateHex()
        self.updatePreview()
    }
       
    func updatePreview() {
        self.view.alphaValue = 1
        self.view.layer?.backgroundColor = self.color.value.cgColor
    }
    
    func updateHex() {
        let hex = NSColor(hexString: self.hexField.stringValue)?.getHexString()
        if (hex != self.color.hexvalue) {
            self.hexField.stringValue = self.color.hexvalue
        }
        // Reset Warning status
        self.hexField.backgroundColor = NSColor.white
        self.warning.isHidden = true
    }
    
    override func controlTextDidChange(_ obj: Notification) {
        if (validateHex(self.hexField.stringValue)) {
            self.hexField.backgroundColor = NSColor.white
            self.warning.isHidden = true
            self.color.update(NSColor(hexString: self.hexField.stringValue)!)
        } else {
            self.warning.isHidden = false
            self.hexField.backgroundColor = NSColor.red
        }
    }

    func validateHex(_ value: String) -> Bool {
        let regexp = try! NSRegularExpression(pattern: "^#?([0-9A-Fa-f]{6}|[0-9A-Fa-f]{3})$", options: NSRegularExpression.Options.caseInsensitive)
        let valueRange = NSRange(location:0, length: value.characters.count )
        let result = regexp.rangeOfFirstMatch(in: value, options: .anchored, range: valueRange)
        if (result.location == NSNotFound) {
            // regexp validation failed
            return false
        }
        else {
            return true
        }
    }
}

class CCAForegroundColourPreviewController: CCAColourPreviewController {
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.color = CCAColourForeground.sharedInstance
        self.updateHex()
        self.updatePreview()
        NotificationCenter.default.addObserver(self, selector: #selector(CCAColourPreviewController.update(_:)), name: NSNotification.Name(rawValue: "ForegroundColorChangedNotification"), object: nil)
    }
}

class CCABackgroundColourPreviewController: CCAColourPreviewController {
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.color = CCAColourBackground.sharedInstance
        self.updateHex()
        self.updatePreview()
        NotificationCenter.default.addObserver(self, selector: #selector(CCAColourPreviewController.update(_:)), name: NSNotification.Name(rawValue: "BackgroundColorChangedNotification"), object: nil)
    }
}
