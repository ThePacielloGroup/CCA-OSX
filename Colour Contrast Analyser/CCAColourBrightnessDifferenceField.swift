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
    
    override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)

        // Drawing code here.
    }
    func setFail() {
        if (currentStatus == true) {
            self.statusImage.image = NSImage(named: "No")
            currentStatus = false;
        }
    }
    
    func setPass() {
        if (currentStatus == false) {
            self.statusImage.image = NSImage(named: "Yes")
            currentStatus = true;
        }
    }
    
    func validateColourBrightnessDifference(brightness:Int, colour:Int) {
        if brightness > 125 && colour > 500 {
            self.setPass();
        } else {
            self.setFail();
        }
    }
}
