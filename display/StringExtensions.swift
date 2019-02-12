//
//  StringExtensions.swift
//  display
//
//  Created by Ben Hanrahan on Tuesday 2/12/19.
//  Copyright © 2019 Ning Ma. All rights reserved.
//

import Foundation

public extension String {
    // To check text field or String is blank or not
    func isBlank() -> Bool {
        let trimmed = trimmingCharacters(in: CharacterSet.whitespaces)
        return trimmed.isEmpty
    }
    
    /**
     Used to check if the string is in the email format.
     
     - Returns: A bool for whether or not it is a valid email address
     */
    func isEmail() -> Bool {
        do {
            let regex = try NSRegularExpression(pattern: "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$", options: .caseInsensitive)
            return regex.firstMatch(in: self, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.count)) != nil
        } catch {
            return false
        }
    }
    
    /**
     Used to check if the password is in the proper format for Firebase, which is 8 chars
     
     - Returns: A bool for whether or not it is a valid password for Firebase
     */
    func isPasswordValid() -> Bool {
        return (self.count >= 8)
    }
    
    // validate PhoneNumber, try a few different types of constructions
    func isPhoneNumber() -> Bool {
        do {
            let regex = try NSRegularExpression(pattern: "\\(\\d{3}\\)\\s\\d{3}-\\d{4}", options: [])
            return regex.firstMatch(in: self, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.count)) != nil
        } catch {
            return false
        }
    }
    
    // validate zipcode
    func isZipCode() -> Bool {
        do {
            let regex = try NSRegularExpression(pattern: "^\\d{5}$", options: [])
            return regex.firstMatch(in: self, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.count)) != nil
        } catch {
            return false
        }
    }
    
    /**
     Encoded a string in base 64
     
     - Parameter toEncode: whatever it is you want to encode
     
     - Returns: the encoded string as an NSObject
     */
    func base64Encode() -> String {
        let utf8Data = self.data(using: String.Encoding.utf8)
        return utf8Data!.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
    }
    
    /**
     Returns a list of strings the regex matches in the string.
     
     - Parameter regex: The pattern you want to match
     - Parameter text: The string you want to extract matches from
     
     - Returns: An array of the matching strings
     */
    func matchesForRegexInString(_ regex: String!) -> [String] {
        
        do {
            let regex = try NSRegularExpression(pattern: regex, options: NSRegularExpression.Options.caseInsensitive)
            let nsString = self as NSString
            let results = regex.matches(in: self, options: NSRegularExpression.MatchingOptions.reportCompletion, range: NSMakeRange(0, nsString.length))
            
            return results.map({nsString.substring(with: $0.range)})
        } catch {
            return []
        }
    }
    
    // TODO make this a bit more robust
    func formatPhoneNumber() -> String {
        var newString = self
        if self.contains("+") {
            newString = (self as NSString).substring(from: 2)
        }
        
        let components = newString.components(separatedBy: CharacterSet.decimalDigits.inverted)
        
        let decimalString = components.joined(separator: "") as NSString
        let length = decimalString.length
        let hasLeadingOne = length > 0 && decimalString.character(at: 0) == (1 as unichar)
        
        var index = 0 as Int
        let formattedString = NSMutableString()
        
        if hasLeadingOne
        {
            formattedString.append("1 ")
            index += 1
        }
        if (length - index) > 3
        {
            let areaCode = decimalString.substring(with: NSMakeRange(index, 3))
            formattedString.appendFormat("(%@) ", areaCode)
            index += 3
        }
        if length - index > 3
        {
            let prefix = decimalString.substring(with: NSMakeRange(index, 3))
            formattedString.appendFormat("%@-", prefix)
            index += 3
        }
        
        let remainder = decimalString.substring(from: index)
        formattedString.append(remainder)
        
        return formattedString as String
    }
}
