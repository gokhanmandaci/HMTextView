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
    
    // MARK: - Outlets
    @IBOutlet weak var hmTextView: HMTextView!
    
    // MARK: - Action
    @IBAction func gokhanAction(_ sender: Any) {
        self.hmTextView.addLink("Gokhan", type: .hashtag, withReplacing: true)
    }
    @IBAction func cagriAction(_ sender: Any) {
        self.hmTextView.addLink("Cagri", type: .mention)
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hmTextViewDelegate = self
        
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(ViewController.tapped(_:)))
        view.addGestureRecognizer(tapGesture)
        
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
    
    func links(_ links: HMLinks) {
        print("HMTextView returned links: \(links)")
    }
    
    func readyToEnter(link_with type: HMType) {
        if type == .hashtag {
            print("Ready to enter hashtag")
        } else {
            print("Ready to enter mention")
        }
    }
}
