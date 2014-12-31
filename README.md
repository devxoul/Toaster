JLToast - Toast for Swift
=========================

[![CocoaPods](http://img.shields.io/cocoapods/v/JLToast.svg)](http://cocoapods.org/?q=name%3AJLToast%20author%3Adevxoul)

Android-like toast with very simple interface.


At a Glance
-----------

```swift
JLToast.makeText("Some text").show()
```


Installation
------------

Use [CocoaPods](http://cocoapods.org). Minimum requiredment version of CocoaPods is **0.36**, which supports Swift frameworks.

_**Note:** CocoaPods 0.36 is just a beta yet, so you need to install CocoaPods prerelease via `$ gem install cocoapods --pre`_

**Podfile**

```ruby
pod 'JLToast'
```


Setting Duration and Delay
--------------------------

```swift
JLToast.makeText("Some text", duration: JLToastDelay.LongDelay)
JLToast.makeText("Some text", delay: 1, duration: JLToastDelay.ShortDelay)
```


Screenshots
-----------

![First Screenshot](https://raw.github.com/Joyfl/JLToast/master/Screenshots/JLToast-Screenshot-1.png)
<br />
![Second Screenshot](https://raw.github.com/Joyfl/JLToast/master/Screenshots/JLToast-Screenshot-2.png)
<br />
![Third Screenshot](https://raw.github.com/Joyfl/JLToast/master/Screenshots/JLToast-Screenshot-3.png)


License
-------

JLToast is under [WTFPL](http://www.wtfpl.net/). You can do what the fuck you want with JLToast. See LICENSE file for more info.