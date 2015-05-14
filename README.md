JLToast - Toast for Swift
=========================

[![CocoaPods](http://img.shields.io/cocoapods/v/JLToast.svg?style=flat)](http://cocoapods.org/?q=name%3AJLToast%20author%3Adevxoul)

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

### iOS 8+

Use [CocoaPods](https://cocoapods.org). Minimum required version of CocoaPods is 0.36, which supports Swift frameworks.

**Podfile**

```ruby
pod 'JLToast'
```


### iOS 7

I recommend you to try [CocoaSeeds](https://github.com/devxoul/CocoaSeeds), which uses source code instead of dynamic framework.

**Seedfile**

```ruby
github 'devxoul/JLToast', '1.2.2', :files => 'JLToast/*.{swift,h}'
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

JLToast is under [WTFPL](http://www.wtfpl.net/). You can do what the fuck you want with JLToast. See LICENSE file for more info.
I
