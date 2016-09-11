Toaster - Toast for Swift
=========================

![Swift 2.0](https://img.shields.io/badge/Swift-2.2-orange.svg)
[![CocoaPods](http://img.shields.io/cocoapods/v/Toast.svg?style=flat)](http://cocoapods.org/?q=name%3AToaster%20author%3Adevxoul)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

Android-like toast with very simple interface.


At a Glance
-----------

```swift
Toast.makeText("Some text").show()
```


Features
--------

- **Queueing**: centralized toast center manages toast queue.
- **Customizable**: see [Appearance](https://github.com/devxoul/Toaster#appearance) section.


Installation
------------

- **For iOS 8+ projects with [CocoaPods](https://cocoapods.org):**

    ```ruby
    pod 'Toaster', '~> 1.4'
    ```
    
- **For iOS 8+ projects with [Carthage](https://github.com/Carthage/Carthage):**

    ```
    github "devxoul/Toaster" ~> 1.0
    ```
    
- **For iOS 7 projects:** I recommend you to try [CocoaSeeds](https://github.com/devxoul/CocoaSeeds), which uses source code instead of dynamic frameworks. Sample Seedfile:

    ```ruby
    github 'devxoul/Toaster', '1.4.2', :files => 'Sources/*.{swift,h}'
    ```


Setting Duration and Delay
--------------------------

```swift
Toast.makeText("Some text", duration: ToastDelay.LongDelay)
Toast.makeText("Some text", delay: 1, duration: ToastDelay.ShortDelay)
```


Removing Toasts
---------------

- **Removing toast with reference**:

    ```swift
    let toast = Toast.makeText("Hello")
    toast.show()
    toast.cancel() // remove toast immediately
    ```
    
- **Removing current toast**:

    ```swift
    if let currentToast = ToastCenter.defaultCenter.currentToast {
        currentToast.cancel()
    }
    ```
    
- **Removing all toasts**:

    ```swift
    ToastCenter.defaultCenter.cancelAllToasts()
    ```


Appearance
----------

Since Toaster 1.1.0, you can set default values for appearance attributes. The code below sets default background color to red.

> **Note:** It is not recommended to set default values while toasts are queued. It can occur unexpected results.

```swift
ToastView.setDefaultValue(
    UIColor.redColor(),
    forAttributeName: ToastViewBackgroundColorAttributeName,
    userInterfaceIdiom: .Phone
)
```


#### Supported Attributes

| Attribute | Type | Description |
|---|---|---|
| `ToastViewBackgroundColorAttributeName` | `UIColor` | Background color |
| `ToastViewCornerRadiusAttributeName` | `NSNumber(CGFloat)` | Corner radius |
| `ToastViewTextInsetsAttributeName` | `NSValue(UIEdgeInsets)` | Text inset |
| `ToastViewTextColorAttributeName` | `UIColor` | Text color |
| `ToastViewFontAttributeName` | `UIFont` | Font |
| `ToastViewPortraitOffsetYAttributeName` | `NSNumber(CGFloat)` | Vertical offfset from bottom in portrait mode |
|` ToastViewLandscapeOffsetYAttributeName` | `NSNumber(CGFloat)` | Vertical offfset from bottom in landscape mode |


Screenshots
-----------

![Toaster Screenshot](https://raw.github.com/devxoul/Toaster/master/Screenshots/Toaster.png)


License
-------

Toaster is under [WTFPL](http://www.wtfpl.net/). You can do what the fuck you want with Toast. See [LICENSE](LICENSE) file for more info.
