//
//  CCAPickerWindowController.swift
//  Colour Contrast Analyser
//
//  Created by Cédric Trévisan on 17/02/2015.
//  Copyright (c) 2015 Cédric Trévisan. All rights reserved.
//

import Cocoa
import CoreGraphics
import AppKit

class CCAPickerController: NSWindowController {

    @IBOutlet var pickerWindow: NSWindow!
    @IBOutlet weak var pickerView: CCAPickerView!
    @IBOutlet weak var hexaText: NSTextField!
    
    var color: CCAColour!
    var cgImage:CGImage?
    var dimension:UInt = 0
    var rawColor:NSColor?
    
    let DEFAULT_DIMENSION:UInt = 128
    
    override func windowWillLoad() {
        super.windowWillLoad()
        
        //        NSEvent.addGlobalMonitorForEventsMatchingMask(NSEventMask.MouseMovedMask, handler: handlerEventGlobal)
        NSEvent.addLocalMonitorForEvents(matching: NSEvent.EventTypeMask.mouseMoved, handler: handlerEventLocal)
        dimension = DEFAULT_DIMENSION / 8
        
        NSEvent.addLocalMonitorForEvents(matching: NSEvent.EventTypeMask.keyDown) { (aEvent) -> NSEvent? in
            self.keyDown(with: aEvent)
            return aEvent
        }
    }
    
    override func windowDidLoad() {
        super.windowDidLoad()

        /* Set always on top */
        pickerWindow.level = NSWindow.Level(rawValue: Int(CGWindowLevelForKey(CGWindowLevelKey.floatingWindow)))
    }
    
    override func mouseUp(with theEvent: NSEvent) {
        print(self.pickerWindow.colorSpace!)
        print(self.rawColor!)
        let color = self.rawColor!.usingColorSpace(self.pickerWindow.colorSpace!)
        print(color!)
        self.color.update(color!)
        self.close()
    }
    
    override func keyDown(with theEvent: NSEvent) {
        if (theEvent.keyCode == 53){
            self.close()
        }
    }

    func open(_ color:CCAColour) {
        self.color = color
        // Hide the mouse
        CGDisplayHideCursor(CGMainDisplayID())

        super.showWindow(nil)
    }
    
    override func close() {
        // Unhide the mouse
        CGDisplayShowCursor(CGMainDisplayID())
        super.close()
    }
    
    /*
    func handlerEventGlobal(aEvent: (NSEvent!)) -> Void {
        mouseMoved(aEvent)
        pickerView.mouseMoved(aEvent)
    }*/
    
    func handlerEventLocal(_ aEvent: (NSEvent!)) -> NSEvent {
        mouseMoved(with: aEvent)
        pickerView.mouseMoved(with: aEvent)
        return aEvent
    }

    override func mouseMoved(with theEvent:NSEvent) {
        let mouseLocation:NSPoint = NSEvent.mouseLocation
        var center:NSPoint = mouseLocation
        center.x -= 64
        center.y -= 64
        // Center the windows to the mouse
        pickerWindow.setFrameOrigin(center)
        
        
        let screen = getScreenRect(mouseLocation)
        var location:NSPoint = mouseLocation
        location.y = screen.size.height - mouseLocation.y
        
        let cgi = imageAtLocation(location)
        
        let rect:NSRect = pickerView.bounds

//        let context:CGContext! = NSGraphicsContext.currentContext()?.CGContext

//        CGContextSetInterpolationQuality(context, CGInterpolationQuality.None)
//        CGContextSetShouldAntialias(context, false)
        
        pickerView.updateView(cgi, rect: rect)
        
        // getting color
        self.rawColor = colorAtLocation(location)
        
        hexaText.backgroundColor = self.rawColor!
        hexaText.stringValue = self.rawColor!.getHexString()
    }
    
    func getScreenRect(_ point:NSPoint) -> NSRect {
        var screenRect:NSRect?
        if let screens = NSScreen.screens as [NSScreen]? {
            for screen in screens {
                if NSMouseInRect(point, screen.frame, false) {
                    screenRect = screen.frame
                }
            }
        }
        return screenRect!
    }
    
    func colorAtLocation(_ location: NSPoint) -> NSColor {
        var windowID = CGWindowID(0)
        if pickerWindow.windowNumber > 0 {
            windowID = CGWindowID(pickerWindow.windowNumber)
        }

        let imageRect:CGRect = CGRect(x: location.x, y: location.y, width: 1, height: 1)
        let imageRef:CGImage = CGWindowListCreateImage(
            imageRect,
            CGWindowListOption.optionOnScreenBelowWindow,
            windowID,
            CGWindowImageOption.bestResolution)!
        let bitmap: NSBitmapImageRep = NSBitmapImageRep(cgImage: imageRef)
        return bitmap.colorAt(x: 0, y:0)!
    }

    func imageAtLocation(_ location: NSPoint) -> CGImage {
        var windowID = CGWindowID(0)
        if pickerWindow.windowNumber > 0 {
            windowID = CGWindowID(pickerWindow.windowNumber)
        }
        
        let imageRect:CGRect = CGRect(x: location.x - 8, y: location.y - 8, width: 16, height: 16)
        let imageRef:CGImage = CGWindowListCreateImage(
            imageRect,
            CGWindowListOption.optionOnScreenBelowWindow,
            windowID,
            CGWindowImageOption.bestResolution)!
        return imageRef
    }
}
