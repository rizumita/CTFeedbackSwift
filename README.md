# CTFeedbackSwift
CTFeedbackSwift is a framework to compose a feedback for iOS 9.0+

[CTFeedback](https://github.com/rizumita/CTFeedback) is written in Objective-C. CTFeedbackSwift is rebooted with Swift.

## Install

CTFeedbackSwift is now support Carthage.

Cartfile

```
github "rizumita/CTFeedbackSwift"
```

And do along Carthage documents.

## How to use

```Swift
let configuration = FeedbackConfiguration(toRecipients: ["test@example.com"], usesHTML: true)
let controller    = FeedbackViewController(configuration: configuration)
navigationController?.pushViewController(controller, animated: true)
```

## License

MIT License
