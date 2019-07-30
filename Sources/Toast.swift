import UIKit

public class Delay: NSObject {
  @available(*, unavailable) private override init() {}
  // `short` and `long` (lowercase) are reserved words in Objective-C
  // so we capitalize them instead of the default `short_` and `long_`
  @objc(Short) public static let short: TimeInterval = 2.0
  @objc(Long) public static let long: TimeInterval = 3.5
}

open class Toast: Operation {

  // MARK: Properties

  @objc public var text: String? {
    get { return self.view.text }
    set { self.view.text = newValue }
  }
  
  @objc public var attributedText: NSAttributedString? {
    get { return self.view.attributedText }
    set { self.view.attributedText = newValue }
  }

  @objc public var delay: TimeInterval
  @objc public var duration: TimeInterval

  private var _executing = false
  override open var isExecuting: Bool {
    get {
      return self._executing
    }
    set {
      self.willChangeValue(forKey: "isExecuting")
      self._executing = newValue
      self.didChangeValue(forKey: "isExecuting")
    }
  }

  private var _finished = false
  override open var isFinished: Bool {
    get {
      return self._finished
    }
    set {
      self.willChangeValue(forKey: "isFinished")
      self._finished = newValue
      self.didChangeValue(forKey: "isFinished")
    }
  }


  // MARK: UI

  @objc public var view: ToastView = ToastView()


  // MARK: Initializing

  /// Initializer.
  /// Instantiates `self.view`, so must be called on main thread.
  @objc public init(text: String?, delay: TimeInterval = 0, duration: TimeInterval = Delay.short) {
    self.delay = delay
    self.duration = duration
    super.init()
    self.text = text
  }

  @objc public init(attributedText: NSAttributedString?, delay: TimeInterval = 0, duration: TimeInterval = Delay.short) {
    self.delay = delay
    self.duration = duration
    super.init()
    self.attributedText = attributedText
  }
  

  // MARK: Factory (Deprecated)

  @available(*, deprecated, message: "Use 'init(text:)' instead.")
  public class func makeText(_ text: String) -> Toast {
    return Toast(text: text)
  }

  @available(*, deprecated, message: "Use 'init(text:duration:)' instead.")
  public class func makeText(_ text: String, duration: TimeInterval) -> Toast {
    return Toast(text: text, duration: duration)
  }

  @available(*, deprecated, message: "Use 'init(text:delay:duration:)' instead.")
  public class func makeText(_ text: String?, delay: TimeInterval, duration: TimeInterval) -> Toast {
    return Toast(text: text, delay: delay, duration: duration)
  }


  // MARK: Showing

  @objc public func show() {
    ToastCenter.default.add(self)
  }


  // MARK: Cancelling

  open override func cancel() {
    super.cancel()
    self.finish()
    self.view.removeFromSuperview()
  }


  // MARK: Operation Subclassing

  override open func start() {
    let isRunnable = !self.isFinished && !self.isCancelled && !self.isExecuting
    guard isRunnable else { return }
    guard Thread.isMainThread else {
      DispatchQueue.main.async { [weak self] in
        self?.start()
      }
      return
    }
    main()
  }

  override open func main() {
    self.isExecuting = true

    DispatchQueue.main.async {
      self.view.setNeedsLayout()
      self.view.alpha = 0
      ToastWindow.shared.addSubview(self.view)

      UIView.animate(
        withDuration: 0.5,
        delay: self.delay,
        options: .beginFromCurrentState,
        animations: {
          self.view.alpha = 1
        },
        completion: { completed in
          if ToastCenter.default.isSupportAccessibility {
            #if swift(>=4.2)
            UIAccessibility.post(notification: .announcement, argument: self.view.text)
            #else
            UIAccessibilityPostNotification(UIAccessibilityAnnouncementNotification, self.view.text)
            #endif
          }
          UIView.animate(
            withDuration: self.duration,
            animations: {
              self.view.alpha = 1.0001
            },
            completion: { completed in
              self.finish()
              UIView.animate(
                withDuration: 0.5,
                animations: {
                  self.view.alpha = 0
                },
                completion: { completed in
                  self.view.removeFromSuperview()
                }
              )
            }
          )
        }
      )
    }
  }

  func finish() {
    self.isExecuting = false
    self.isFinished = true
  }

}
