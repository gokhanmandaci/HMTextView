//
//  ViewController.swift
//  HMTextView
//
//  Created by gokhanmandaci on 02/20/2020.
//  Copyright (c) 2020 gokhanmandaci. All rights reserved.
//

import UIKit
import HMTextView

class ViewController: UIViewController {
    // MARK: - Parameters
    private var tapGesture: UITapGestureRecognizer!
    private var hashtags = [String]()
    private var mentions = [String]()
    private var enableAddingMention: Bool = true
    
    // MARK: - Outlets
    @IBOutlet weak var hmTextView: HMTextView!
    
    // MARK: - Action
    @IBAction func gokhanAction(_ sender: Any) {
        self.hmTextView.addLink("Gokhan", type: .hashtag, withReplacing: true)
    }
    @IBAction func cagriAction(_ sender: Any) {
        if enableAddingMention {
            self.hmTextView.addLink("Cagri", type: .mention)
        }
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hmTextViewDelegate = self
        
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(ViewController.tapped(_:)))
        view.addGestureRecognizer(tapGesture)
        
        hmTextView.lineSpacing = 15
        hmTextView.kern = -0.59
        
        hmTextView.charCount = 160
        
        hmTextView.textAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15)
        ]
        hmTextView.linkAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.red
        ]
        hmTextView.hashtagFont = UIFont.boldSystemFont(ofSize: 20)
        hmTextView.mentionFont = UIFont.boldSystemFont(ofSize: 12)

    }
    
    /// Tap gesture recognizer action. Closes keyboard.
    @objc private func tapped(_ gesture: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
}

extension ViewController: HMTextViewProtocol {    
    func clicked(on link: String, type: HMType) {
        if type == .hashtag {
            print("HMTextView clicked on: \(link) of type Hashtag")
        } else {
            print("HMTextView clicked on: \(link) of type Mention")
        }
    }
    
    func links(hashtags: [String], mentions: [String]) {
        print("HMTextView returned hashtags: \(hashtags)")
        print("HMTextView returned mentions: \(mentions)")
        
        self.hashtags = hashtags
        self.mentions = mentions
        
        print("Self Hashtags: \(self.hashtags)")
        print("Self Mentions: \(self.mentions)")
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
}
