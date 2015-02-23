//
//  CCAPickerWindowController.swift
//  Colour Contrast Analyser
//
//  Created by Cédric Trévisan on 17/02/2015.
//  Copyright (c) 2015 Cédric Trévisan. All rights reserved.
//

import Cocoa

struct Flags {
    var _Xlocked:Bool = false
    var _Ylocked:Bool = false
    var _XYlocked:Bool = false
    var _posX: Character = Character("_")
    var _posY: Character = Character("_")
}

class CCAPickerController: NSWindowController {

    @IBOutlet var pickerWindow: CCAPickerWindow!
    @IBOutlet weak var pickerView: CCAPickerView!
    @IBOutlet weak var hexaText: NSTextField!
    
    var cgImage:CGImage?
    var flags:Flags = Flags()
    var dimension:UInt = 0
    var location:NSPoint?
    var color:NSColor?
    
    let DEFAULT_DIMENSION:UInt = 128

    override func windowDidLoad() {
        super.windowDidLoad()
        
        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
        
        /* Set always on top */
        pickerWindow.level = Int(CGWindowLevelForKey(Int32(kCGFloatingWindowLevelKey)))

        //        NSEvent.addGlobalMonitorForEventsMatchingMask(NSEventMask.MouseMovedMask, handler: handlerEventGlobal)
        NSEvent.addLocalMonitorForEventsMatchingMask(NSEventMask.MouseMovedMask, handler: handlerEventLocal)
        location = NSEvent.mouseLocation()
        dimension = DEFAULT_DIMENSION / 8
        createImage(location!)
    }
    
    override func mouseUp(theEvent: NSEvent) {
        NSNotificationCenter.defaultCenter().postNotificationName("ColorSelectedNotification", object: nil)
    }
    
    /*
    func handlerEventGlobal(aEvent: (NSEvent!)) -> Void {
        mouseMoved(aEvent)
        pickerView.mouseMoved(aEvent)
    }*/
    
    func handlerEventLocal(aEvent: (NSEvent!)) -> NSEvent {
        mouseMoved(aEvent)
        pickerView.mouseMoved(aEvent)
        return aEvent
    }

    override func mouseMoved(theEvent:NSEvent) {
        let mouseLocation:NSPoint = NSEvent.mouseLocation()
        var center:NSPoint = mouseLocation
        center.x -= 64
        center.y -= 64
        // Center the windows to the mouse
        pickerWindow.setFrameOrigin(center)
        
        if flags._XYlocked {
            return;
        }
        
        if flags._Xlocked {
            location?.y = mouseLocation.y
        } else {
            location?.x = mouseLocation.x
        }
        
        if flags._Ylocked {
            location?.x = mouseLocation.x
        } else {
            location?.y = mouseLocation.y
        }
        createImage(location!)
        
        var rect:NSRect = pickerView.bounds
        
        let context = NSGraphicsContext.currentContext()!.CGContext
        
        CGContextSetInterpolationQuality(context, kCGInterpolationNone)
        CGContextSetShouldAntialias(context, false)
        
        if cgImage != nil {
            let w:UInt = CGImageGetWidth(cgImage) * (DEFAULT_DIMENSION / dimension);
            let h:UInt = CGImageGetHeight(cgImage) * (DEFAULT_DIMENSION / dimension);
            if (w < DEFAULT_DIMENSION || h < DEFAULT_DIMENSION) {
                CGContextSetRGBFillColor(context, 0.0, 0.0, 0.0, 1.0);
                CGContextFillRect(context, NSRectToCGRect(rect));
                
                if flags._posX == Character ("R") {
                    rect.origin.x += CGFloat(DEFAULT_DIMENSION) - CGFloat(w)
                }
                if flags._posY == Character("T") {
                    rect.origin.y += CGFloat(DEFAULT_DIMENSION) - CGFloat(h)
                }
            }
            
            rect.size.width = CGFloat(w)
            rect.size.height = CGFloat(h)
            
            pickerView.updateView(cgImage!, rect: rect)
            
            // getting color
            //            let pixel:NSColor = NSReadPixel(NSMakePoint(66.0, 66.0))
            let imageRep:NSBitmapImageRep = NSBitmapImageRep(CGImage: cgImage!)
            let pixel:NSColor = imageRep.colorAtX(8, y: 7)!
            // reseting previous color
            if color != nil {
                color = nil
            }
            color = pixel
            hexaText.backgroundColor = color
            hexaText.stringValue = color!.getHexString()
        }
    }
    
    func createImage(point:NSPoint) {
        var x, y, w, h:CGFloat
        let screenRect = NSScreen.mainScreen()!.frame
        
        let point_y = screenRect.size.height - point.y
        let point_x = point.x
        let fdimension:CGFloat = CGFloat(dimension)
        
        var windowID = CGWindowID(0)
        if pickerWindow.windowNumber > 0 {
            windowID = CGWindowID(pickerWindow.windowNumber)
        }
        
        flags._posX = Character("L")
        flags._posY = Character("B")
        
        x = (point_x - (fdimension / 2.0))
        if x > 0.0 {
            if (point_x + (fdimension / 2.0)) > screenRect.size.width {
                w = (fdimension / 2.0) + screenRect.size.width - point_x
            } else {
                w = fdimension
            }
        } else {
            x = 0.0;
            w = fdimension + (point_x - (fdimension / 2.0))
            w = w > fdimension ? fdimension : w
            flags._posX = Character("R")
        }
        
        y = (point_y - (fdimension / 2.0))
        
        if y > 1.0 {
            if (point_y + (fdimension / 2.0)) > screenRect.size.height - 1.0 {
                h = ((fdimension / 2.0) + screenRect.size.height - 1 - point_y)
                flags._posY = Character("T")
            } else {
                h = fdimension
            }
        } else {
            y = 1.0;
            h = fdimension + 1.0 + (point_y - (fdimension / 2.0))
            h = h > fdimension ? fdimension : h
        }
        
        if (cgImage != nil) {
            cgImage = nil
        }
        
        let imageRect = NSMakeRect(x, y, w, h)
        cgImage = CGWindowListCreateImage(
            imageRect,
            CGWindowListOption(kCGWindowListOptionOnScreenBelowWindow),
            windowID,
            CGWindowImageOption(kCGWindowImageBestResolution)).takeRetainedValue()
    }
}
