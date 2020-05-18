//
//  ViewController.swift
//  HMTextView
//
//  Created by gokhanmandaci on 02/20/2020.
//  Copyright (c) 2020 gokhanmandaci. All rights reserved.
//

import HMTextView
import UIKit

class ViewController: UIViewController {
    // MARK: - Parameters
    private var tapGesture: UITapGestureRecognizer!
    private var hashtags = [String]()
    private var mentions = [String]()
    private var enableAddingMention: Bool = true
    var predefinedLink: String?
    var predefinedType: HMType?
    
    // MARK: - Outlets
    @IBOutlet weak var hmTextView: HMTextView!
    
    // MARK: - Action
    @IBAction func gokhanAction(_ sender: Any) {
        hmTextView.addLink("Gokhan", type: .hashtag, withReplacing: true)
    }
    
    @IBAction func cagriAction(_ sender: Any) {
        if enableAddingMention {
            hmTextView.addLink("Cagri", type: .mention)
        }
    }
    
    @IBAction func addOneNumberAction(_ sender: Any) {
        let time = "1"
        hmTextView.addLink(time, type: .hashtag, withReplacing: false)
    }
    
    @IBAction func addMultipleNumbersAction(_ sender: Any) {
        let time = "123"
        hmTextView.addLink(time, type: .hashtag, withReplacing: false)
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hmTextViewDelegate = self
        
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(ViewController.tapped(_:)))
        view.addGestureRecognizer(tapGesture)
        
        // HM TextView Configuration -- START
        hmTextView.lineSpacing = 15
        hmTextView.kern = -0.59
        hmTextView.charCount = 160
        hmTextView.allowLinksStartWithNumber = true
        hmTextView.minimumLinkCharCount = 1
        hmTextView.regex = "(?<=\\s|^)([@#][\\p{L}\\d]+[._:][\\p{L}\\d]+|[#@][\\p{L}\\d]*)(?=[']\\p{L}+|[.,;:?!](?:\\s|$)|\\s|$)"
        hmTextView.textAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.purple,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15)
        ]
        hmTextView.linkAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.red
        ]
        hmTextView.hashtagFont = UIFont.boldSystemFont(ofSize: 20)
        hmTextView.mentionFont = UIFont.boldSystemFont(ofSize: 12)
        // -- END
        
        if let link = predefinedLink, let type = predefinedType {
            hmTextView.addLink(link, type: type)
        }
    }
    
    /// Tap gesture recognizer action. Closes keyboard.
    @objc private func tapped(_ gesture: UITapGestureRecognizer) {
        view.endEditing(true)
    }
}

extension ViewController: HMTextViewProtocol {
    func didChange(_ textView: UITextView) {
        print("HMTextView did change: \(textView.text ?? "")")
    }
    
    func links(hashtags: [String], mentions: [String]) {
        print("HMTextView returned hashtags: \(hashtags)")
        print("HMTextView returned mentions: \(mentions)")
        
        self.hashtags = hashtags
        self.mentions = mentions
        
        print("Self Hashtags: \(self.hashtags)")
        print("Self Mentions: \(self.mentions)")
    }
    
    func clicked(on link: String, type: HMType) {
        if type == .hashtag {
            print("HMTextView clicked on: \(link) of type Hashtag")
        } else {
            print("HMTextView clicked on: \(link) of type Mention")
        }
    }
    
    func shouldBeginEditing(_ textView: UITextView) {
        print("HMTextView should begin editing: \(textView.text ?? "")")
    }
    
    func didEndEditing(_ textView: UITextView) {
        print("HMTextView did end editing: \(textView.text ?? "")")
    }
    
    func didBeginEditing(_ textView: UITextView) {
        print("HMTextView did begin editing: \(textView.text ?? "")")
    }
    
    func didChangeSelection(_ textView: UITextView) {
        print("HMTextView did change editing: \(textView.text ?? "")")
    }
    
    func shouldEndEditing(_ textView: UITextView) {
        print("HMTextView should end editing: \(textView.text ?? "")")
    }
    
    func readyToEnter(link_with type: HMType) {
        if type == .hashtag {
            print("Ready to enter hashtag")
        } else {
            print("Ready to enter mention")
        }
    }
    
    func stoppedEntering(link_with type: HMType) {
        if type == .hashtag {
            print("Stopped entering hashtag")
        } else {
            print("Stopped entering mention")
        }
    }
    
    func charLimitReached() {
        print("HMTextView char limit reached")
    }
    
    func charLimitAvailable() {
        print("HMTextView char limit available")
    }
    
    func chars(_ written: Int, _ remained: Int) {
        print(remained)
        print("******")
        print(" @Cagri ".count)
        if remained < " @Cagri ".count {
            print("Char limit reached")
            enableAddingMention = false
        } else {
            enableAddingMention = true
        }
    }
    
    func shouldChangeTextIn(_ textView: UITextView, _ range: NSRange, _ replacementText: String, _ returning: Bool) {
        print("HMTextView should change text in: \(textView.text ?? "")\nwith range: \(range)\nwith replacement text:\(replacementText)\nreturning: \(returning)")
    }
}
