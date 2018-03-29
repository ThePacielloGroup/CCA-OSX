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
    
    var rgbaString: String {
        get {
            let red = Int(round(self.redComponent * 0xFF))
            let grn = Int(round(self.greenComponent * 0xFF))
            let blu = Int(round(self.blueComponent * 0xFF))
            return NSString(format: "rgba(%lu, %lu, %lu, %g)", red, grn, blu, self.alphaComponent) as String
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
        self.init(hexString: string, alpha: 1.0)
    } else if(NSColor.isRGBA(string: string)) {
        self.init(rgbaString: string)
    } else {
        print("Can't initialise color, string format error")
        self.init()
        return nil
    }
  }

      /**
        Create non-autoreleased color with in the given hex string and alpha
     
        :param:   hexString
        :param:   alpha
        :returns: color with the given hex string and alpha
      */
      convenience init?(hexString: String, alpha: CGFloat) {
        var value:   UInt32 = 0
        
        let scanner = Scanner(string: hexString)
        scanner.charactersToBeSkipped = CharacterSet(charactersIn: "#")
        
        scanner.scanHexInt32(&value)
        
        let r:CGFloat = CGFloat((value & 0xFF0000) >> 16) / 255.0
        let g:CGFloat = CGFloat((value & 0xFF00) >> 8) / 255.0
        let b:CGFloat = CGFloat((value & 0xFF)) / 255.0
        
        self.init(red: r, green: g, blue: b, alpha: alpha)
      }

    /**
     Create non-autoreleased color with in the given rgba string
     
     :param:   rgbaString
     :returns: color with the given rgba string and alpha
     */
    convenience init?(rgbaString: String) {
        var redInt:   Int = 0
        var greenInt: Int = 0
        var blueInt:  Int = 0
        var alphaFloat: Float = 0.0
        
        let scanner = Scanner(string: rgbaString)
        scanner.charactersToBeSkipped = NSCharacterSet.decimalDigits.inverted
        
        scanner.scanInt(&redInt)
        scanner.scanInt(&greenInt)
        scanner.scanInt(&blueInt)
        scanner.scanFloat(&alphaFloat)

        self.init(red: CGFloat(redInt) / 255.0, green: CGFloat(greenInt) / 255.0, blue: CGFloat(blueInt) / 255.0, alpha: CGFloat(alphaFloat))
    }

    
  /**
    Create non-autoreleased color with in the given hex value
    Alpha will be set as 1 by default
    
    :param:   hex
    :returns: color with the given hex value
  */
  convenience init?(hex: Int) {
    self.init(hex: hex, alpha: 1.0)
  }
  
  /**
    Create non-autoreleased color with in the given hex value and alpha
    
    :param:   hex
    :param:   alpha
    :returns: color with the given hex value and alpha
  */
  convenience init?(hex: Int, alpha: CGFloat) {
    let hexString = NSString(format: "%2X", hex) as String
    self.init(hexString: hexString, alpha: alpha)
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
        let regexp = try! NSRegularExpression(pattern: "^#?[0-9A-Fa-f]{6}$", options: NSRegularExpression.Options.caseInsensitive)
        let valueRange = NSRange(location:0, length: string.count )
        let result = regexp.rangeOfFirstMatch(in: string, options: .anchored, range: valueRange)
        return (result.location != NSNotFound)
    }

    static func isRGBA(string: String) -> Bool {
        let lcstring = string.lowercased()
        let regexp = try! NSRegularExpression(pattern: "^(?:rgba?)?[\\s]?[\\(]?[\\s+]?\\d{1,3}[(\\s)|(,)]+[\\s+]?\\d{1,3}[(\\s)|(,)]+[\\s+]?\\d{1,3}[(\\s)|(,)]+[\\s+]?(?:0(?:\\.\\d+)?|1(?:\\.0)?)[\\)]?$", options: NSRegularExpression.Options.caseInsensitive)
        let valueRange = NSRange(location:0, length: lcstring.count )
        let result = regexp.rangeOfFirstMatch(in: lcstring, options: .anchored, range: valueRange)
        return (result.location != NSNotFound)
    }
}
