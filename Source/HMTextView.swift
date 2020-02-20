//
//  HMTextView.swift
//  HMTextView
//
//  Created by gokhan on 20.02.2020.
//  Copyright © 2020 gokhan. All rights reserved.
//

import UIKit

open class HMTextView: UITextView {
    // MARK: - Parameters
    private enum HMType {
        case hashtag
        case mention
    }
    
    // Configuration Parameters
    /**
     Main regex for detecting hashtag and mention. You Can update this with your own
    
     ### Default: ###
     ````
    UIFont.boldSystemFont(ofSize: 17)
     ````
    */
    public var regex = "(?<=\\s|^)([@#][\\p{L}\\d]+[._]\\p{L}+|[#@][\\p{L}\\d]*)(?=[']\\p{L}+|[.,;:?!](?:\\s|$)|\\s|$)"
//    public var regex = "(?<=\\s|^)([#@]\\d*\\p{L}+\\d*[_-][\\p{L}\\d]+|[#@]\\d*\\p{L}+\\d*)(?=[']\\p{L}+|[.,;:?!]|\\s|$)"
    
    /**
      Updates the hashtag font.
     
      ### Default: ###
      ````
     UIFont.boldSystemFont(ofSize: 17)
      ````
     */
    public var hashtagFont: UIFont = UIFont.boldSystemFont(ofSize: 17)
    
    /**
      Updates the mention font.
     
      ### Default: ###
      ````
     UIFont.boldSystemFont(ofSize: 17)
      ````
     */
    public var mentionFont: UIFont = UIFont.boldSystemFont(ofSize: 17)
    
    /**
      Update general text attributes.
     
      ### Default: ###
      ````
     [
         NSAttributedString.Key.foregroundColor: UIColor.black,
         NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17)
     ]
      ````
     */
    public var textAttributes = [
        NSAttributedString.Key.foregroundColor: UIColor.black,
        NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17)
    ]
    
    /**
     Update link attributes.
    
     ### Default: ###
     ````
    System default link colors and attributes
     ````
    */
    public var linkAttributes: [NSAttributedString.Key: Any]! {
        didSet {
            self.linkTextAttributes = self.linkAttributes
        }
    }
    
    // MARK: - Initializers
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        
        self.setupTextView()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        
        self.setupTextView()
    }
    
    private func setupTextView() {
        self.delegate = self
    }
}

// MARK: - Methods
extension HMTextView {
    /**
     Returns hashtag and mention words in textview
     */
    private func getMatched(words from: String, for regex: String) -> [String] {
        do {
            let regex = try NSRegularExpression(pattern: regex)
            let results = regex.matches(in: text, range: NSRange(text.startIndex..., in: text))
            return results.map {
                String(text[Range($0.range, in: text)!])
            }
        } catch {
            print("HMTextView Regex Error: \(error.localizedDescription)")
            return []
        }
    }
    
    /**
     Detects hashtag and mention words in text and sets attributed strings
     */
    private func detectLinks() {
        let words = self.getMatched(words: self.text, for: self.regex)
        
        let attrString = NSMutableAttributedString(string: self.text, attributes: self.textAttributes)
        for word in words {
            if word.count < 3 {
                continue
            }
            // Hashtag Part
            if word.hasPrefix("#"), let hm = getHM(word) {
                attrString.addAttribute(.link, value: "hash:\(hm.0)", range: hm.1)
                attrString.addAttribute(.font, value: self.hashtagFont, range: hm.1)
            } else if word.hasPrefix("@"), let hm = getHM(word) {
                attrString.addAttribute(.link, value: "mention:\(hm.0)", range: hm.1)
                attrString.addAttribute(.font, value: self.mentionFont, range: hm.1)
            }
        }
        self.attributedText = attrString
    }
    
    /**
     Returns word alone and the range in the text.
     */
    private func getHM(_ word: String) -> (String.SubSequence, NSRange)? {
        let nsString = NSString(string: self.text)
        let range: NSRange = nsString.range(of: word as String)
        let substring = word.dropFirst()
        if let firstChar = substring.unicodeScalars.first,
            !NSCharacterSet.decimalDigits.contains(firstChar) {
            return (substring, range)
        }
        return nil
    }
}

extension HMTextView: UITextViewDelegate {
    public func textViewDidChange(_ textView: UITextView) {
        self.detectLinks()
    }
}
