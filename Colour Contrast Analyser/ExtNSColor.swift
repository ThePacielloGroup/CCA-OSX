import Cocoa

extension NSColor {
    var hexString: String {
        get {
            let red = Int(round(self.redComponent * 0xFF))
            let grn = Int(round(self.greenComponent * 0xFF))
            let blu = Int(round(self.blueComponent * 0xFF))
            return NSString(format: "#%02X%02X%02X", red, grn, blu) as String
        }
    }
    
    var rgbString: String {
        get {
            let red = Int(round(self.redComponent * 0xFF))
            let grn = Int(round(self.greenComponent * 0xFF))
            let blu = Int(round(self.blueComponent * 0xFF))
            return NSString(format: "rgb(%lu, %lu, %lu)", red, grn, blu) as String
        }
    }

    var hslString: String {
        get {
            let hue = Int(round(self.hueComponent * 360))
            let saturation = Int(round(self.saturationComponent * 100))
            let brightness = Int(round(self.brightnessComponent * 100))
            return NSString(format: "hsl(%lu, %lu%%, %lu%%)", hue, saturation, brightness) as String
        }
    }
    
    var nameString: String {
        get {
            let rHex = (Int(round(255 * self.redComponent)) & 0xff) << 16
            let gHex = (Int(round(255 * self.greenComponent)) & 0xff) << 8
            let bHex = (Int(round(255 * self.blueComponent)) & 0xff)
            let hex = rHex + gHex + bHex
            guard let name = (colorKeywordMap.first { $0.value == hex })?.key
            else {
                    return ""
            }
            return name
        }
    }
    
    convenience init?(redInt: Int, greenInt: Int, blueInt:Int) {
        self.init(red: CGFloat(redInt) / 255.0, green: CGFloat(greenInt) / 255.0, blue: CGFloat(blueInt) / 255.0, alpha: 1.0)
    }

    convenience init?(redDouble: Double, greenDouble: Double, blueDouble:Double) {
        self.init(red: CGFloat(redDouble), green: CGFloat(greenDouble), blue: CGFloat(blueDouble), alpha: 1.0)
    }
  /**
    Create non-autoreleased color with in the given hex string
    Alpha will be set as 1 by default
    
    :param:   hexString
    :returns: color with the given hex string
  */
  convenience init?(string: String) {
    if (NSColor.isHex(string: string)) {
        self.init(hexString: string)
    } else if(NSColor.isRGB(string: string)) {
        self.init(rgbString: string)
    } else if(NSColor.isName(string: string)) {
        self.init(nameString: string)
    } else {
        print("Can't initialise color, string format error")
        self.init()
        return nil
    }
  }

      /**
        Create non-autoreleased color with in the given hex string
     
        :param:   hexString
        :returns: color with the given hex string
      */
      convenience init?(hexString: String) {
        let (redInt, greenInt, blueInt) = NSColor.parseHex(string: hexString)
        self.init(red: CGFloat(redInt) / 255.0, green: CGFloat(greenInt) / 255.0, blue: CGFloat(blueInt) / 255.0, alpha: 1.0)
      }

    static func parseHex(string: String) -> (UInt32, UInt32, UInt32) {
        var value:   UInt32 = 0
        
        let scanner = Scanner(string: string)
        scanner.charactersToBeSkipped = CharacterSet(charactersIn: "#")
        
        scanner.scanHexInt32(&value)
        
        let redInt:   UInt32 = (value & 0xFF0000) >> 16
        let greenInt: UInt32 = (value & 0xFF00) >> 8
        let blueInt:  UInt32 = (value & 0xFF)

        return (redInt, greenInt, blueInt)
    }
    
    /**
     Create non-autoreleased color with in the given rgb string
     
     :param:   rgbString
     :returns: color with the given rgb string
     */
    convenience init?(rgbString: String) {
        let (redInt, greenInt, blueInt) = NSColor.parseRGB(string: rgbString)
        self.init(red: CGFloat(redInt) / 255, green: CGFloat(greenInt) / 255, blue: CGFloat(blueInt) / 255, alpha: 1.0)
    }
    
    static func parseRGB(string: String) -> (Int, Int, Int) {
        var redInt:   Int = 0
        var greenInt: Int = 0
        var blueInt:  Int = 0
        
        let scanner = Scanner(string: string)
        scanner.charactersToBeSkipped = NSCharacterSet.decimalDigits.inverted
        
        scanner.scanInt(&redInt)
        scanner.scanInt(&greenInt)
        scanner.scanInt(&blueInt)
        return (redInt, greenInt, blueInt)
    }
    
    /**
     Create non-autoreleased color with in the given rgba string
     
     :param:   rgbaString
     :returns: color with the given rgba string
     */
    convenience init?(rgbaString: String) {
        let (redInt, greenInt, blueInt, alphaFloat) = NSColor.parseRGBA(string: rgbaString)
        self.init(red: CGFloat(redInt) / 255, green: CGFloat(greenInt) / 255, blue: CGFloat(blueInt) / 255, alpha: CGFloat(alphaFloat))
    }

    static func parseRGBA(string: String) -> (Int, Int, Int, Float) {
        var redInt:   Int = 0
        var greenInt: Int = 0
        var blueInt:  Int = 0
        var alphaFloat: Float = 0.0
        
        let scanner = Scanner(string: string)
        scanner.charactersToBeSkipped = NSCharacterSet.decimalDigits.inverted
        
        scanner.scanInt(&redInt)
        scanner.scanInt(&greenInt)
        scanner.scanInt(&blueInt)
        scanner.scanFloat(&alphaFloat)
        return (redInt, greenInt, blueInt, alphaFloat)
    }
    
    /**
     Create non-autoreleased color with in the given hsl string
     
     :param:   hslString
     :returns: color with the given hsl string
     */
    convenience init?(hslString: String) {
        let (hueInt, saturationInt, brightnessInt) = NSColor.parseHSL(string: hslString)
        self.init(calibratedHue: CGFloat(hueInt) / 360.0, saturation: CGFloat(saturationInt) / 100.0, brightness: CGFloat(brightnessInt) / 100, alpha: 1.0)
    }
    
    static func parseHSL(string: String) -> (Int, Int, Int) {
        var hueInt:   Int = 0
        var saturationInt: Int = 0
        var brightnessInt:  Int = 0
        
        let scanner = Scanner(string: string)
        scanner.charactersToBeSkipped = NSCharacterSet.decimalDigits.inverted
        
        scanner.scanInt(&hueInt)
        scanner.scanInt(&saturationInt)
        scanner.scanInt(&brightnessInt)
        return (hueInt, saturationInt, brightnessInt)
    }
    
    convenience init?(nameString: String) {
        let hex = NSColor.parseName(string: nameString)
        self.init(hex: hex)
    }
    
    static func parseName(string: String) -> Int {
        let cstring = string.lowercased()
        return (colorKeywordMap.first(where: { $0.key.lowercased() == cstring })?.value)!
    }

    /**
     Creates and returns a `NSColor` object using the given hex color code. Or returns `nil` if color code is invalid.
     */
    public convenience init?(hex: Int) {
        guard (0...0xFFFFFF).contains(hex) else {
            return nil
        }
        
        let r = (hex & 0xFF0000) >> 16
        let g = (hex & 0x00FF00) >> 8
        let b = (hex & 0x0000FF)
        
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: 1.0)
    }

    func getRInt() -> Int {
        return Int(round(self.redComponent * 255))
    }
    func getGInt() -> Int {
        return Int(round(self.greenComponent * 255))
    }
    func getBInt() -> Int {
        return Int(round(self.blueComponent * 255))
    }
    func getRDouble() -> Double {
        return Double(round(self.redComponent * 255))
    }
    func getGDouble() -> Double {
        return Double(round(self.greenComponent * 255))
    }
    func getBDouble() -> Double {
        return Double(round(self.blueComponent * 255))
    }
    
    func grayScaleComponent() -> CGFloat {
        return (
            0.29900 * self.redComponent +
            0.58700 * self.greenComponent +
            0.11400 * self.blueComponent
        )
    }
    
    func isBlack() -> Bool {
        return (self.redComponent == 0 && self.greenComponent == 0 && self.blueComponent == 0)
    }
    
    static func isHex(string: String) -> Bool {
        let cstring = string.uppercased()
        let regexp = try! NSRegularExpression(pattern: "^#?[0-9A-F]{6}$", options: NSRegularExpression.Options.caseInsensitive)
        let valueRange = NSRange(location:0, length: cstring.count )
        let result = regexp.rangeOfFirstMatch(in: cstring, options: .anchored, range: valueRange)
        return (result.location != NSNotFound)
    }

    static func isRGBA(string: String) -> Bool {
        let cstring = string.lowercased()
        let regexp = try! NSRegularExpression(pattern: "^(?:rgba)?[\\s]?[\\(]?[\\s+]?\\d{1,3}[(\\s)|(,)]+[\\s+]?\\d{1,3}[(\\s)|(,)]+[\\s+]?\\d{1,3}[(\\s)|(,)]+[\\s+]?(?:0(?:\\.\\d+)?|1(?:\\.0)?)[\\)]?$", options: NSRegularExpression.Options.caseInsensitive)
        let valueRange = NSRange(location:0, length: cstring.count )
        let result = regexp.rangeOfFirstMatch(in: cstring, options: .anchored, range: valueRange)
        return (result.location != NSNotFound)
    }
    
    static func isRGB(string: String) -> Bool {
        let cstring = string.lowercased()
        let regexp = try! NSRegularExpression(pattern: "^(?:rgb)?[\\s]?[\\(]?[\\s+]?\\d{1,3}[(\\s)|(,)]+[\\s+]?\\d{1,3}[(\\s)|(,)]+[\\s+]?\\d{1,3}[\\s]?[\\)]?$", options: NSRegularExpression.Options.caseInsensitive)
        let valueRange = NSRange(location:0, length: cstring.count )
        let result = regexp.rangeOfFirstMatch(in: cstring, options: .anchored, range: valueRange)
        return (result.location != NSNotFound)
    }
    
    static func isHSL(string: String) -> Bool {
        let cstring = string.lowercased()
        let regexp = try! NSRegularExpression(pattern: "^(?:hsl)?[\\s]?[\\(]?[\\s+]?\\d{1,3}[(\\s)|(,)]+[\\s+]?\\d{1,3}%[(\\s)|(,)]+[\\s+]?\\d{1,3}%[\\s]?[\\)]?$", options: NSRegularExpression.Options.caseInsensitive)
        let valueRange = NSRange(location:0, length: cstring.count )
        let result = regexp.rangeOfFirstMatch(in: cstring, options: .anchored, range: valueRange)
        return (result.location != NSNotFound)
    }
    
    static func isName(string: String) -> Bool {
        let cstring = string.lowercased()
        guard let _ = colorKeywordMap.first(where: { $0.key.lowercased() == cstring })?.value
        else {
            return false
        }
        return true
    }
}


