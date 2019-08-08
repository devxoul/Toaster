import UIKit

open class ToastCenter: NSObject {

  // MARK: Properties

  private let queue: OperationQueue = {
    let queue = OperationQueue()
    queue.maxConcurrentOperationCount = 1
    return queue
  }()

  open var currentToast: Toast? {
    return self.queue.operations.first { !$0.isCancelled && !$0.isFinished } as? Toast
  }
  
  /// If this value is `true` and the user is using VoiceOver,
  /// VoiceOver will announce the text in the toast when `ToastView` is displayed.
  @objc public var isSupportAccessibility: Bool = true
  
  /// By default, queueing for toast is enabled.
  /// If this value is `false`, only the last requested toast will be shown.
  @objc public var isQueueEnabled: Bool = true
  
  @objc public static let `default` = ToastCenter()


  // MARK: Initializing

  override init() {
    super.init()
    #if swift(>=4.2)
    let name = UIDevice.orientationDidChangeNotification
    #else
    let name = NSNotification.Name.UIDeviceOrientationDidChange
    #endif
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(self.deviceOrientationDidChange),
      name: name,
      object: nil
    )
  }


  // MARK: Adding Toasts

  open func add(_ toast: Toast) {
    if !isQueueEnabled {
      cancelAll()
    }
    self.queue.addOperation(toast)
  }


  // MARK: Cancelling Toasts

  @objc open func cancelAll() {
    queue.cancelAllOperations()
  }


  // MARK: Notifications

  @objc dynamic func deviceOrientationDidChange() {
    if let lastToast = self.queue.operations.first as? Toast {
      lastToast.view.setNeedsLayout()
    }
  }

}
