Toaster
=======

[![Build Status](https://travis-ci.org/devxoul/Toaster.svg?branch=master)](https://travis-ci.org/devxoul/Toaster)
![Swift](https://img.shields.io/badge/Swift-5.0-orange.svg)
[![CocoaPods](https://img.shields.io/cocoapods/v/Toaster.svg?style=flat)](https://cocoapods.org/?q=name%3AToaster%20author%3Adevxoul)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

Android-like toast with very simple interface. (formerly JLToast)


Screenshots
-----------

![Toaster Screenshot](https://raw.github.com/devxoul/Toaster/master/Screenshots/Toaster.png)


Features
--------

- **Queueing**: Centralized toast center manages the toast queue.
- **Customizable**: See the [Appearance](#appearance) section.
- **String** or **AttributedString**: Both supported.
- **UIAccessibility**: VoiceOver support.


At a Glance
-----------

```swift
import Toaster

Toast(text: "Hello, world!").show()
```


Installation
------------

- **For iOS 8+ projects with [CocoaPods](https://cocoapods.org):**

    ```ruby
    pod 'Toaster'
    ```

- **For iOS 8+ projects with [Carthage](https://github.com/Carthage/Carthage):**

    ```
    github "devxoul/Toaster"
    ```


Getting Started
---------------

### Setting Duration and Delay

```swift
Toast(text: "Hello, world!", duration: Delay.long)
Toast(text: "Hello, world!", delay: Delay.short, duration: Delay.long)
```

### Removing Toasts

- **Removing toast with reference**:

    ```swift
    let toast = Toast(text: "Hello")
    toast.show()
    toast.cancel() // remove toast immediately
    ```

- **Removing current toast**:

    ```swift
    if let currentToast = ToastCenter.default.currentToast {
        currentToast.cancel()
    }
    ```

- **Removing all toasts**:

    ```swift
    ToastCenter.default.cancelAll()
    ```

### Appearance

Since Toaster 2.0.0, you can use `UIAppearance` to set default appearance. This is an short example to set default background color to red.

```swift
ToastView.appearance().backgroundColor = .red
```

Supported appearance properties are:

| Property | Type | Description |
|---|---|---|
| `backgroundColor` | `UIColor` | Background color |
| `cornerRadius` | `CGFloat` | Corner radius |
| `textInsets` | `UIEdgeInsets` | Text inset |
| `textColor` | `UIColor` | Text color |
| `font` | `UIFont` | Font |
| `bottomOffsetPortrait` | `CGFloat` | Vertical offfset from bottom in portrait mode |
| `bottomOffsetLandscape` | `CGFloat` | Vertical offfset from bottom in landscape mode |
| `shadowPath` | `CGPath` | The shape of the layer’s shadow |
| `shadowColor` | `UIColor` | The color of the layer’s shadow |
| `shadowOpacity` | `Float` | The opacity of the layer’s shadow |
| `shadowOffset` | `CGSize` | The offset (in points) of the layer’s shadow |
| `shadowRadius` | `CGFloat` | The blur radius (in points) used to render the layer’s shadow |
| `maxWidthRatio` | `CGFloat` | The width ratio of toast view in window |
| `useSafeAreaForBottomOffset` | `Bool` | A Boolean value that determines `safeAreaInsets.bottom` is added to `bottomOffset` |

### Attributed string

Since Toaster 2.3.0, you can also set an attributed string:

```swift
Toast(attributedText: NSAttributedString(string: "AttributedString Toast", attributes: [NSAttributedString.Key.backgroundColor: UIColor.yellow]))
```

### Accessibility

By default, VoiceOver with UIAccessibility is enabled since Toaster 2.3.0. To disable it:
```swift
ToastCenter.default.isSupportAccessibility = false
```


License
-------

Toaster is under [WTFPL](http://www.wtfpl.net/). You can do what the fuck you want with Toast. See [LICENSE](LICENSE) file for more info.
