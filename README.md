JLToast - Toast for Swift
=========================

![Swift 2.0](https://img.shields.io/badge/Swift-2.2-orange.svg)
[![CocoaPods](http://img.shields.io/cocoapods/v/JLToast.svg?style=flat)](http://cocoapods.org/?q=name%3AJLToast%20author%3Adevxoul)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

Android-like toast with very simple interface.


At a Glance
-----------

```swift
JLToast.makeText("Some text").show()
```


Features
--------

- **Objective-C Compatible**: import `JLToast.h` to use JLToast in Objective-C.
- **Queueing**: centralized toast center manages toast queue.
- **Customizable**: see [Appearance](https://github.com/devxoul/JLToast#appearance) section.


Installation
------------

- **For iOS 8+ projects with [CocoaPods](https://cocoapods.org):**

    ```ruby
    pod 'JLToast', '~> 1.4'
    ```
    
- **For iOS 8+ projects with [Carthage](https://github.com/Carthage/Carthage):**

    ```
    github "devxoul/JLToast" ~> 1.0
    ```
    
- **For iOS 7 projects:** I recommend you to try [CocoaSeeds](https://github.com/devxoul/CocoaSeeds), which uses source code instead of dynamic frameworks. Sample Seedfile:

    ```ruby
    github 'devxoul/JLToast', '1.4.2', :files => 'JLToast/*.{swift,h}'
    ```


Objective-C
-----------

JLToast is compatible with Objective-C. What you need to do is to import a auto-generated header file:

```objc
#import <JLToast/JLToast-Swift.h>
```

If you are looking for constants, import `JLToast.h`.

```objc
#import <JLToast/JLToast-Swift.h>
#import <JLToast/JLToast.h> // if you want to use constants
```


Setting Duration and Delay
--------------------------

```swift
JLToast.makeText("Some text", duration: JLToastDelay.LongDelay)
JLToast.makeText("Some text", delay: 1, duration: JLToastDelay.ShortDelay)
```


Removing Toasts
---------------

- **Removing toast with reference**:

    ```swift
    let toast = JLToast.makeText("Hello")
    toast.show()
    toast.cancel() // remove toast immediately
    ```
    
- **Removing current toast**:

    ```swift
    if let currentToast = JLToastCenter.defaultCenter.currentToast {
        currentToast.cancel()
    }
    ```
    
- **Removing all toasts**:

    ```swift
    JLToastCenter.defaultCenter.cancelAllToasts()
    ```


Appearance
----------

Since JLToast 1.1.0, you can set default values for appearance attributes. The code below sets default background color to red.

> **Note:** It is not recommended to set default values while toasts are queued. It can occur unexpected results.

**Swift**

```swift
JLToastView.setDefaultValue(
    UIColor.redColor(),
    forAttributeName: JLToastViewBackgroundColorAttributeName,
    userInterfaceIdiom: .Phone
)
```

**Objective-C**

```objc
[JLToastView setDefaultValue:[UIColor redColor]
            forAttributeName:JLToastViewBackgroundColorAttributeName
          userInterfaceIdiom:UIUserInterfaceIdiomPhone];
```


#### Supported Attributes

| Attribute | Type | Description |
|---|---|---|
| `JLToastViewBackgroundColorAttributeName` | `UIColor` | Background color |
| `JLToastViewCornerRadiusAttributeName` | `NSNumber(CGFloat)` | Corner radius |
| `JLToastViewTextInsetsAttributeName` | `NSValue(UIEdgeInsets)` | Text inset |
| `JLToastViewTextColorAttributeName` | `UIColor` | Text color |
| `JLToastViewFontAttributeName` | `UIFont` | Font |
| `JLToastViewPortraitOffsetYAttributeName` | `NSNumber(CGFloat)` | Vertical offfset from bottom in portrait mode |
|` JLToastViewLandscapeOffsetYAttributeName` | `NSNumber(CGFloat)` | Vertical offfset from bottom in landscape mode |


Screenshots
-----------

![JLToast Screenshot](https://raw.github.com/Joyfl/JLToast/master/Screenshots/JLToast.png)


License
-------

JLToast is under [WTFPL](http://www.wtfpl.net/). You can do what the fuck you want with JLToast. See [LICENSE](LICENSE) file for more info.
