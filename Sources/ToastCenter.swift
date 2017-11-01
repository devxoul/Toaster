import UIKit

open class ToastCenter {

  // MARK: Properties

  private let queue: OperationQueue = {
    let queue = OperationQueue()
    queue.maxConcurrentOperationCount = 1
    return queue
  }()

  open var currentToast: Toast? {
    return self.queue.operations.first { !$0.isCancelled && !$0.isFinished } as? Toast
  }

  open static let `default` = ToastCenter()


  // MARK: Initializing

  init() {
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(self.deviceOrientationDidChange),
      name: .UIDeviceOrientationDidChange,
      object: nil
    )
  }


  // MARK: Adding Toasts

  open func add(_ toast: Toast) {
    self.queue.addOperation(toast)
  }


  // MARK: Cancelling Toasts

  open func cancelAll() {
    queue.cancelAllOperations()
  }


  // MARK: Notifications

  @objc dynamic func deviceOrientationDidChange() {
    if let lastToast = self.queue.operations.first as? Toast {
      lastToast.view.setNeedsLayout()
    }
  }

}
