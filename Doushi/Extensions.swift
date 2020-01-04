//
//  Extensions.swift
//  Doushi
//
//  Created by Suraj Sau on 03/01/20.
//  Copyright © 2020 Suraj Sau. All rights reserved.
//

import Foundation

/*
    String extensions
 */

let hiraganaRegex = try! NSRegularExpression(pattern: "[\\U00003040-\\U0000309F]", options: [])

extension String {
    
    func usageToHiragana() -> String {
        return self.replacingOccurrences(of: "ガ", with: "が")
            .replacingOccurrences(of: "ヲ", with: "を")
            .replacingOccurrences(of: "ノ", with: "の")
            .replacingOccurrences(of: "ト", with: "と")
            .replacingOccurrences(of: "ハ", with: "は")
            .replacingOccurrences(of: "ニ", with: "に")
    }
    
    func transitiveEnglish() -> String {
        switch self {
        case "他":
            return "transitive"
        case "自（意志)":
            return "volitional intransitive"
        case "自":
            return "intransitive"
        default:
            return ""
        }
    }
    
    func isEnglish() -> Bool {
        return false
    }
    
    func isHiragana() -> Bool {
        return hiraganaRegex.matches(self)
    }
    
}

extension NSRegularExpression {
    
    func matches(_ string: String) -> Bool {
        let range = NSRange(location: 0, length: string.utf16.count)
        return numberOfMatches(in: string, options: [], range: range) == string.count
    }
    
}

/*
    Meaning extensions
 */
extension Meaning {
    
    func toListModel(usagePattern: String) -> MeaningListModel {
        let parts = usagePattern.split(separator: ":")
        var usagePatterns: [String] = []
        
        for part in parts {
            usagePatterns.append(part.replacingOccurrences(of: "|", with: " "))
        }
        
        return MeaningListModel(meaning: self.meaning?.replacingOccurrences(of: "(1)", with: "").replacingOccurrences(of: "(2)", with: ""),
                                example: self.example,
                                usage: usagePatterns)
    }
    
}
