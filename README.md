# HMTextView

[![Version](https://img.shields.io/cocoapods/v/HMTextView.svg?style=flat)](https://cocoapods.org/pods/HMTextView)
[![Platform](https://img.shields.io/cocoapods/p/HMTextView.svg?style=flat)](https://cocoapods.org/pods/HMTextView)

[Regex Reference and Android Version (.kt)](https://github.com/santalu/textmatcher "Santalu's TextMatcher Repo")

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

### Manual

1. Clone this repo
2. Navigate to project folder
3. Copy `Source` to your project


### Using Cocoapods

HMTextView is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'HMTextView'
```

## Usage
1. `import HMTextView` in which class you want to use.
2. Create a UITextView with class `HMTextView`
3. Update configuration parameters if necessary.

## Code

In your view controller after creating a HMTextView, for example called `hmTextView`

### Protocols

```
HMTextView Specific
/// Returns all links in the text view
func links(hashtags: [String], mentions: [String])
/// Click event of a link
func clicked(on link: String, type: HMType)
/// When enter a'#' or '@'
func readyToEnter(link_with type: HMType)
/// When stopped entering a link
func stoppedEntering(link_with type: HMType)
/// When character limit reached
func charLimitReached()
/// If character limit will not be reached
func charLimitAvailable()
/// Chars written so far and remained char count
func chars(_ written: Int, _ remained: Int)

Common Methods
/// Same with textViewShouldBeginEditing
func shouldBeginEditing(_ textView: UITextView)
/// Same with textViewDidEndEditing
func didEndEditing(_ textView: UITextView)
/// Same with textViewDidBeginEditing
func didBeginEditing(_ textView: UITextView)
/// Same with textViewDidChangeSelection
func didChangeSelection(_ textView: UITextView)
/// Same with textViewShouldEndEditing
func shouldEndEditing(_ textView: UITextView)
/// Same with textViewDidChange
func didChange(_ textView: UITextView)
/// Same with shouldChangeTextIn
func shouldChangeTextIn(_ textView: UITextView,
                        _ range: NSRange,
                        _ replacementText: String,
                        _ returning: Bool)
```

### Configuration

```
override func viewDidLoad() {
    super.viewDidLoad()
    
    hmTextViewDelegate = self
    
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
```

## Configuration Parameters

```
/// Main regex for detecting hashtag and mention. You Can update this with your own.<br/>
public var regex = "(?<=\\s|^)([@#][\\p{L}\\d]+[._]\\p{L}+|[#@][\\p{L}\\d]*)(?=[']\\p{L}+|[.,;:?!](?:\\s|$)|\\s|$)"

/// Line spacing of the paragraph style.
public var lineSpacing: CGFloat = 0

/// Letter spacing of the paragraph style.
public var kern: CGFloat = 0.0

/// Allow links start with numbers.
public var allowLinksStartWithNumber: Bool = false

/// Set minimum character count for links.
public var minimumLinkCharCount: Int = 3

/// Turn this to false if you don't want to highlight hashtags.
public var detectHashtags: Bool = true

/// Turn this to false if you don't want to highlight mentions.
public var detectMentions: Bool = true

/// Updates the hashtag font.
public var hashtagFont: UIFont = UIFont.boldSystemFont(ofSize: 17)

/// Updates the mention font.
public var mentionFont: UIFont = UIFont.boldSystemFont(ofSize: 17)

/// Update general text attributes.
public var textAttributes = [
    NSAttributedString.Key.foregroundColor: UIColor.black,
    NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17)
]

/// Update link attributes.
public var linkAttributes: [NSAttributedString.Key: Any]! {
    didSet {
        self.linkTextAttributes = self.linkAttributes
    }
}

/// Character count.
public var charCount: Int = -1
```

## Resources Used: <br/>
https://www.hackingwithswift.com/articles/108/how-to-use-regular-expressions-in-swift <br/>
https://stackoverflow.com/a/48938881 <br/>
https://stackoverflow.com/a/24144365 <br/>

## Author

gokhanmandaci, gokhanmandaci@gmail.com

## License

HMTextView is available under the MIT license. See the LICENSE file for more info.
