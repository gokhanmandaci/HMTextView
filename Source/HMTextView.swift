//
//  HMTextView.swift
//  HMTextView
//
//  Created by gokhan on 20.02.2020.
//  Copyright © 2020 gokhan. All rights reserved.
//

import UIKit

/**
 With this protocol you can get the links (@, #).
 */
public protocol HMTextViewProtocol {
    func links(hashtags: [String], mentions: [String])
    func clicked(on link: String, type: HMType)
    func shouldBeginEditing(_ textView: UITextView)
    func didEndEditing(_ textView: UITextView)
    func didBeginEditing(_ textView: UITextView)
    func didChangeSelection(_ textView: UITextView)
    func shouldEndEditing(_ textView: UITextView)
    func didChange(_ textView: UITextView)
    func readyToEnter(link_with type: HMType)
    func stoppedEntering(link_with type: HMType)
    func charLimitReached()
    func charLimitAvailable()
    func chars(_ written: Int, _ remained: Int)
    func shouldChangeTextIn(_ textView: UITextView,
                            _ range: NSRange,
                            _ replacementText: String,
                            _ returning: Bool)
}

/// Delegate HMTextView protocol.
public var hmTextViewDelegate: HMTextViewProtocol?

public extension HMTextViewProtocol {
    func links(hashtags: [String], mentions: [String]) {}
    func clicked(on link: String, type: HMType) {}
    func shouldBeginEditing(_ textView: UITextView) {}
    func didEndEditing(_ textView: UITextView) {}
    func didBeginEditing(_ textView: UITextView) {}
    func didChangeSelection(_ textView: UITextView) {}
    func shouldEndEditing(_ textView: UITextView) {}
    func didChange(_ textView: UITextView) {}
    func readyToEnter(link_with type: HMType) {}
    func stoppedEntering(link_with type: HMType) {}
    func charLimitReached() {}
    func charLimitAvailable() {}
    func chars(_ written: Int, _ remained: Int) {}
    func shouldChangeTextIn(_ textView: UITextView,
                            _ range: NSRange,
                            _ replacementText: String,
                            _ returning: Bool) {}
}

public enum HMType {
    case hashtag
    case mention
}

public class HMTextView: UITextView {
    // MARK: - Parameters
    private let hashtagRoot: String = "hash:"
    private let mentionRoot: String = "mention:"
    private let isDeleting: Bool = false
    
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
     Line spacing of the paragraph style.
     */
    public var lineSpacing: CGFloat = 0
    
    /**
     Letter spacing of the paragraph style.
     */
    public var kern: CGFloat = 0.0
    
    /**
     If you want to prevent adding numbers in hashtags, make this parameter false.
     */
    public var allowLinksStartWithNumber: Bool = false
    
    /**
     If you want to prevent adding numbers in hashtags, make this parameter false.
     */
    public var minimumLinkCharCount: Int = 3
    
    /**
      Enable detecting hashtags.
     
      ### Default: ###
      ````
     true
      ````
     */
    public var detectHashtags: Bool = true
    
    /**
      Enable detecting mentions.
     
      ### Default: ###
      ````
     true
      ````
     */
    public var detectMentions: Bool = true
    
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
    
    /**
      Character count.
     
      ### Default: ###
      ````
     none
      ````
     */
    public var charCount: Int = -1
    
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
            if word.count < self.minimumLinkCharCount {
                continue
            }
            
            if word.hasPrefix("#"), let hm = getHM(word), detectHashtags {
                for range in hm.1 {
                    attrString.addAttribute(.link, value: "\(self.hashtagRoot)\(hm.0)", range: range)
                    attrString.addAttribute(.font, value: self.hashtagFont, range: range)
                }
            } else if word.hasPrefix("@"), let hm = getHM(word), detectMentions {
                for range in hm.1 {
                    attrString.addAttribute(.link, value: "\(self.mentionRoot)\(hm.0)", range: range)
                    attrString.addAttribute(.font, value: self.mentionFont, range: range)
                }
            }
        }
        let style = NSMutableParagraphStyle()
        style.lineSpacing = self.lineSpacing
        attrString.addAttribute(.kern, value: self.kern, range: NSRange(location: 0, length: attrString.string.count))
        attrString.addAttribute(.paragraphStyle, value: style, range: NSRange(location: 0, length: attrString.string.count))
        self.attributedText = attrString
    }
    
    /**
     Returns word alone and the range in the text.
     */
    private func getHM(_ word: String) -> (String.SubSequence, [NSRange])? {
        let ranges = self.text.ranges(of: word)
        var nsRanges = [NSRange]()
        for range in ranges {
            let nsRange = NSRange(range, in: self.text)
            nsRanges.append(nsRange)
        }
        let substring = word.dropFirst()
        if self.allowLinksStartWithNumber {
            return (substring, nsRanges)
        }
        if let firstChar = substring.unicodeScalars.first,
            !NSCharacterSet.decimalDigits.contains(firstChar) {
            return (substring, nsRanges)
        }
        return nil
    }
    
    /**
     Fills an HMLinks object and returns it. Contains hashtag and mention texts.
     */
    private func getLinks() -> HMLinks {
        var links = HMLinks()
        
        let words = self.getMatched(words: self.text, for: self.regex)
        for word in words {
            if word.count < self.minimumLinkCharCount {
                continue
            }
            if word.hasPrefix("#"), self.detectHashtags {
                links.hashtags.append(String(word.dropFirst()))
            } else if word.hasPrefix("@"), self.detectMentions {
                links.mentions.append(String(word.dropFirst()))
            }
        }
        
        return links
    }
    
    private func getCursorPosition(_ range: UITextRange) -> Int? {
        let cursorPosition = self.offset(from: self.beginningOfDocument, to: range.start)
        return cursorPosition
    }
}

// MARK: - Public Functions
extension HMTextView {
    #warning("TODO: Needs refactoring")
    public func addLink(_ link: String, type: HMType, withReplacing: Bool = false) {
        var prefix = "@"
        if type == .hashtag {
            prefix = "#"
        }
        let attrStr = self.attributedText.string
        if let textRange = self.selectedTextRange,
            let cursorPosition = getCursorPosition(textRange) {
            let cursorMinusOne = cursorPosition - 1
            let cursorPlusOne = cursorPosition + 1
            if attrStr.isEmpty {
                self.replace(textRange, withText: "\(prefix)\(link) ")
            } else {
                if attrStr.count > cursorPosition {
                    // Get chars before and after if there is any.
                    var beforeChar = ""
                    var afterChar = ""
                    if cursorMinusOne > 0, attrStr.count > cursorMinusOne {
                        beforeChar = String(attrStr[cursorMinusOne])
                    }
                    if attrStr.count > cursorPlusOne {
                        afterChar = String(attrStr[cursorPlusOne])
                    }
                    
                    // Check if before and after chars are spaces
                    var mentionUpdated = "\(prefix)\(link)"
                    if beforeChar != " " {
                        mentionUpdated = " " + mentionUpdated
                    } else if beforeChar == prefix {
                        mentionUpdated = "\(link)"
                    }
                    if afterChar != " " {
                        mentionUpdated = mentionUpdated + " "
                    }
                    
                    if withReplacing {
                        let regex = try! NSRegularExpression(pattern: "\\S+$")
                        let textRange = NSRange(location: 0, length: selectedRange.location)
                        if let range = regex.firstMatch(in: text, range: textRange)?.range {
                            let nsString = NSString(string: attrStr)
                            let str = nsString.replacingCharacters(in: range, with: "\(prefix)\(link)") as String
                            self.attributedText = NSMutableAttributedString(string: str)
                            self.detectLinks()
                        }
                        return
                    }
                    
                    self.replace(textRange, withText: mentionUpdated)
                } else {
                    if withReplacing {
                        let regex = try! NSRegularExpression(pattern: "\\S+$")
                        let textRange = NSRange(location: 0, length: cursorPosition)
                        if let range = regex.firstMatch(in: text, range: textRange)?.range {
                            let nsString = NSString(string: attrStr)
                            let str = nsString.replacingCharacters(in: range, with: "\(prefix)\(link)") as String
                            self.attributedText = NSMutableAttributedString(string: str)
                            self.detectLinks()
                        }
                        return
                    }
                    
                    self.replace(textRange, withText: " \(prefix)\(link)")
                }
            }
        } else {
            self.attributedText = NSAttributedString(string: attrStr.trimmingCharacters(in: .whitespaces) + " \(prefix)\(link)")
        }
        self.detectLinks()
    }
}

// MARK: - TextView Delegate
extension HMTextView: UITextViewDelegate {
    public func textViewDidBeginEditing(_ textView: UITextView) {
        hmTextViewDelegate?.didBeginEditing(textView)
    }
    
    public func textViewDidChangeSelection(_ textView: UITextView) {
        hmTextViewDelegate?.didChangeSelection(textView)
    }
    
    public func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        hmTextViewDelegate?.shouldEndEditing(textView)
        
        return true
    }
    
    public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        var isBackspace = false
        let newLength = self.text.count + text.count - range.length
        if newLength < textView.text.count, text == "" {
            print("backspace")
            isBackspace = true
        } else {
            if let textRange = self.selectedTextRange, let position = getCursorPosition(textRange) {
                if position >= textView.text.count {
                    self.detectLinks()
                }
            }
        }
        
        if text.count > 0, text[0] == "@", text != "" {
            hmTextViewDelegate?.readyToEnter(link_with: .mention)
        }
        
        if text.count > 0, text[0] == "#", text != "" {
            hmTextViewDelegate?.readyToEnter(link_with: .hashtag)
        }
        
        if text == " " {
            hmTextViewDelegate?.stoppedEntering(link_with: .hashtag)
            hmTextViewDelegate?.stoppedEntering(link_with: .mention)
        }
        
        if self.charCount != -1 {
            let writtenCharCount = textView.text.count
            let remainedCharCount = self.charCount - newLength
            hmTextViewDelegate?.chars(writtenCharCount, remainedCharCount)
            if newLength <= self.charCount {
                hmTextViewDelegate?.charLimitAvailable()
            } else {
                hmTextViewDelegate?.charLimitReached()
            }
            
            hmTextViewDelegate?.shouldChangeTextIn(textView, range, text, (newLength <= self.charCount || isBackspace))
            return (newLength <= self.charCount || isBackspace)
        }
        
        hmTextViewDelegate?.shouldChangeTextIn(textView, range, text, true)
        return true
    }
    
    public func textViewDidEndEditing(_ textView: UITextView) {
        self.detectLinks()
        let links = self.getLinks()
        hmTextViewDelegate?.links(hashtags: links.hashtags, mentions: links.mentions)
        hmTextViewDelegate?.didEndEditing(textView)
    }
    
    public func textViewDidChange(_ textView: UITextView) {
        hmTextViewDelegate?.didChange(textView)
    }
    
    public func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        let clickedItem = URL.absoluteString
        if clickedItem.contains(self.hashtagRoot) {
            let linkString = clickedItem.replacingOccurrences(of: self.hashtagRoot, with: "")
            hmTextViewDelegate?.clicked(on: linkString, type: .hashtag)
        } else if clickedItem.contains(self.mentionRoot) {
            let linkString = clickedItem.replacingOccurrences(of: self.mentionRoot, with: "")
            hmTextViewDelegate?.clicked(on: linkString, type: .mention)
        }
        return false
    }
    
    public func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        hmTextViewDelegate?.shouldBeginEditing(textView)
        
        return true
    }
    
    /// Returns hashtags in the text view
    public func getHashtags() -> [String] {
        return self.getLinks().hashtags
    }
    
    /// Returns mentions in the text view
    public func getMentions() -> [String] {
        return self.getLinks().mentions
    }
}

extension StringProtocol {
    subscript(offset: Int) -> Character { self[index(startIndex, offsetBy: offset)] }
    subscript(range: Range<Int>) -> SubSequence {
        let startIndex = index(self.startIndex, offsetBy: range.lowerBound)
        return self[startIndex..<index(startIndex, offsetBy: range.count)]
    }
    
    subscript(range: ClosedRange<Int>) -> SubSequence {
        let startIndex = index(self.startIndex, offsetBy: range.lowerBound)
        return self[startIndex..<index(startIndex, offsetBy: range.count)]
    }
    
    subscript(range: PartialRangeFrom<Int>) -> SubSequence { self[index(startIndex, offsetBy: range.lowerBound)...] }
    subscript(range: PartialRangeThrough<Int>) -> SubSequence { self[...index(startIndex, offsetBy: range.upperBound)] }
    subscript(range: PartialRangeUpTo<Int>) -> SubSequence { self[..<index(startIndex, offsetBy: range.upperBound)] }
}

extension String {
    func ranges(of substring: String, options: CompareOptions = [], locale: Locale? = nil) -> [Range<Index>] {
        var ranges: [Range<Index>] = []
        while ranges.last.map({ $0.upperBound < self.endIndex }) ?? true,
            let range = self.range(of: substring, options: options, range: (ranges.last?.upperBound ?? self.startIndex)..<self.endIndex, locale: locale) {
            ranges.append(range)
        }
        return ranges
    }
}

extension StringProtocol {
    var byWords: [SubSequence] {
        var byWords: [SubSequence] = []
        enumerateSubstrings(in: startIndex..., options: .byWords) { _, range, _, _ in
            byWords.append(self[range])
        }
        return byWords
    }
}
