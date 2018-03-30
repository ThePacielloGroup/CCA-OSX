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
    var adjustedColor:NSColor?
    var colorProfiles:[CGDirectDisplayID: NSColorSpace]?
    var currentScreenNumber:CGDirectDisplayID?
    var currentScreenColorSpace:NSColorSpace?
    
    let DEFAULT_DIMENSION:UInt = 128
    let userDefaults = UserDefaults.standard
    
    override func windowWillLoad() {
        super.windowWillLoad()
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
        self.color.update(self.adjustedColor!)
        self.close()
    }
    
    override func keyDown(with theEvent: NSEvent) {
        if (theEvent.keyCode == 53){
            self.close()
        }
    }

    func open(_ color:CCAColour) {
        // Retrieve latest color profiles selections
        let data = userDefaults.object(forKey: "CCAColorProfiles") as! Data
        self.colorProfiles = NSKeyedUnarchiver.unarchiveObject(with: data) as? [CGDirectDisplayID : NSColorSpace]
        
        self.currentScreenNumber = nil
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
    
    func handlerEventLocal(_ aEvent: (NSEvent!)) -> NSEvent {
        mouseMoved(with: aEvent)
        pickerView.mouseMoved(with: aEvent)
        return aEvent
    }

    //Because AppKit and CoreGraphics use different coordinat systems
    func convertPointToScreenCoordinates(point: CGPoint) -> CGPoint {
        let mainscreen = NSScreen.screens.first! // ?? Use the bigger?
        let x:CGFloat = fabs(point.x)
        var y:CGFloat = point.y
        // Flip it
        y = mainscreen.frame.size.height - y
        return CGPoint(x:x, y:y)
    }
    
    override func mouseMoved(with theEvent:NSEvent) {
        let mouseLocation:NSPoint = NSEvent.mouseLocation
        var center:NSPoint = mouseLocation
        center.x -= 64
        center.y -= 64
        // Center the windows to the mouse
        pickerWindow.setFrameOrigin(center)
        
        let screen:NSScreen = NSScreen.getScreen(mouseLocation)
        let screenNumber = screen.number
        if (screenNumber != self.currentScreenNumber) {
            self.currentScreenNumber = screenNumber
            // Get screen color profile
            self.currentScreenColorSpace = self.colorProfiles![screenNumber]
        }

        //Because AppKit and CoreGraphics use different coordinat systems
        let location:NSPoint = convertPointToScreenCoordinates(point: mouseLocation)

        let cgi = imageAtLocation(location)
        let rect:NSRect = pickerView.bounds
        
        pickerView.updateView(cgi, rect: rect)
        
        // getting color
        let rawColor = colorAtCenter(screen: screen, imageRef: cgi)
        self.adjustedColor = rawColor.usingColorSpace(self.currentScreenColorSpace!)
        hexaText.backgroundColor = adjustedColor
        hexaText.stringValue = adjustedColor!.hexString
        
    }
    
    func colorAtCenter(screen:NSScreen, imageRef:CGImage) -> NSColor {
        let bitmap: NSBitmapImageRep = NSBitmapImageRep(cgImage: imageRef)//.converting(to: NSColorSpace.sRGB, renderingIntent: NSColorRenderingIntent(rawValue: 0)!)!
        var color:NSColor
        if (screen.backingScaleFactor == 2.0) { // Retina display
            color = bitmap.colorAt(x: 16, y:16)!
        } else {
            color = bitmap.colorAt(x: 8, y:8)!
        }
        
        // https://stackoverflow.com/questions/46961761/accurately-get-a-color-from-pixel-on-screen-and-convert-its-color-space
        // need a pointer to a C-style array of CGFloat
        let compCount = color.numberOfComponents
        let comps = UnsafeMutablePointer<CGFloat>.allocate(capacity: compCount)
        // get the components
        color.getComponents(comps)
        // construct a new color in the device/bitmap space with the same components
        return NSColor(colorSpace: bitmap.colorSpace,
                                     components: comps,
                                     count: compCount)
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
