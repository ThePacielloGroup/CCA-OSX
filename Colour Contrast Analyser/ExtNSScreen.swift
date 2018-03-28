//
//  ExtNSScreen.swift
//  Colour Contrast Analyser
//
//  Created by Cédric on 27/03/2018.
//  Copyright © 2018 Cédric Trévisan. All rights reserved.
//

import Cocoa

extension NSScreen {
    var number: CGDirectDisplayID {
        let screen_info = self.deviceDescription
        let screen_id = screen_info[NSDeviceDescriptionKey("NSScreenNumber")] as! NSNumber
        return CGDirectDisplayID((screen_id).intValue)
    }
    
    /// The name for the display (usually, the manufacturer and model number).
    /// -Note: This is expensive to get, and should be cached in a stored property.
    var displayName: String {
        guard let info = infoForCGDisplay((self as NSScreen).number, options: kIODisplayOnlyPreferredName) else {
            return "Unknown screen"
        }
        guard let localizedNames = info[kDisplayProductName] as! NSDictionary? as Dictionary?,
            let name           = localizedNames.values.first as! NSString? as String? else {
                return "Unnamed screen"
        }
        return name
    }
    
    static func getScreen(_ point:NSPoint) -> NSScreen {
        var screenRes:NSScreen?
        if let screens = NSScreen.screens as [NSScreen]? {
            for screen in screens {
                if NSMouseInRect(point, screen.frame, false) {
                    screenRes = screen
                }
            }
        }
        return screenRes!
    }
}

/// Returns the IODisplay info dictionary for the given displayID.
///
/// -Returns: The info dictionary for the first screen with the same vendor and model number as the
///           specified screen.
private func infoForCGDisplay(_ displayID: CGDirectDisplayID, options: Int) -> [AnyHashable: Any]? {
    var iter: io_iterator_t = 0
    
    // Initialize iterator.
    let services = IOServiceMatching("IODisplayConnect")
    let err = IOServiceGetMatchingServices(kIOMasterPortDefault, services, &iter)
    guard err == KERN_SUCCESS else {
        NSLog("Could not find services for IODisplayConnect, error code \(err)")
        return nil
    }
    
    // Loop through all screens, looking for a vendor and model ID match.
    var service = IOIteratorNext(iter)
    while service != 0 {
        let info = IODisplayCreateInfoDictionary(service, IOOptionBits(options)).takeRetainedValue()
            as Dictionary as [AnyHashable: Any]
        
        guard let cfVendorID = info[kDisplayVendorID] as! CFNumber?,
            let cfProductID = info[kDisplayProductID] as! CFNumber? else {
                NSLog("Missing vendor or product ID encountered when looping through screens")
                continue
        }
        
        var vendorID: CFIndex = 0, productID: CFIndex = 0
        guard CFNumberGetValue(cfVendorID, .cfIndexType, &vendorID) &&
            CFNumberGetValue(cfProductID, .cfIndexType, &productID) else {
                NSLog("Unexpected failure unwrapping vendor or product ID while looping through "
                    + "screens")
                continue
        }
        
        if UInt32(vendorID) == CGDisplayVendorNumber(displayID) &&
            UInt32(productID) == CGDisplayModelNumber(displayID) {
            return info
        }
        
        service = IOIteratorNext(iter)
    }
    
    return nil
}
