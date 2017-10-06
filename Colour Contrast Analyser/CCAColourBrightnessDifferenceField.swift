//
//  NSColourBrightnessDifferenceField.swift
//  Colour Contrast Analyser
//
//  Created by Cédric Trévisan on 03/02/2015.
//  Copyright (c) 2015 Cédric Trévisan. All rights reserved.
//

import Cocoa

class CCAColourBrightnessDifferenceField: NSTextField {
    @IBOutlet weak var statusImage:NSImageView!
    var currentStatus:Bool = false
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
    }
    func setFail() {
        if (currentStatus == true) {
            self.statusImage.image = NSImage(named: NSImage.Name(rawValue: "No"))
            currentStatus = false;
        }
    }
    
    func setPass() {
        if (currentStatus == false) {
            self.statusImage.image = NSImage(named: NSImage.Name(rawValue: "Yes"))
            currentStatus = true;
        }
    }
    
    func validateColourBrightnessDifference(_ brightness:Int, colour:Int) {
        if brightness > 125 && colour > 500 {
            self.setPass();
        } else {
            self.setFail();
        }
    }
}
