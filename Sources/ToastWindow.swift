import UIKit

open class ToastWindow: UIWindow {
  
  // MARK: - Public Property

  public static let shared = ToastWindow(frame: UIScreen.main.bounds, mainWindow: UIApplication.shared.keyWindow)

  override open var rootViewController: UIViewController? {
    get {
      guard !self.isShowing else {
        isShowing = false
        return nil
      }
      guard !self.isStatusBarOrientationChanging else { return nil }
      guard let firstWindow = UIApplication.shared.delegate?.window else { return nil }
      return firstWindow is ToastWindow ? nil : firstWindow?.rootViewController
    }
    set { /* Do nothing */ }
  }
  
  override open var isHidden: Bool {
    willSet {
      if #available(iOS 13.0, *) {
        isShowing = true
      }
    }
    didSet {
      if #available(iOS 13.0, *) {
        isShowing = false
      }
    }
  }
  
  /// Don't rotate manually if the application:
  ///
  /// - is running on iPad
  /// - is running on iOS 9
  /// - supports all orientations
  /// - doesn't require full screen
  /// - has launch storyboard
  ///
  var shouldRotateManually: Bool {
    let iPad = UIDevice.current.userInterfaceIdiom == .pad
    let application = UIApplication.shared
    let window = application.delegate?.window ?? nil
    let supportsAllOrientations = application.supportedInterfaceOrientations(for: window) == .all
    
    let info = Bundle.main.infoDictionary
    let requiresFullScreen = (info?["UIRequiresFullScreen"] as? NSNumber)?.boolValue == true
    let hasLaunchStoryboard = info?["UILaunchStoryboardName"] != nil
    
    if #available(iOS 9, *), iPad && supportsAllOrientations && !requiresFullScreen && hasLaunchStoryboard {
      return false
    }
    return true
  }
  
  
  // MARK: - Private Property
  
  /// Will not return `rootViewController` while this value is `true`. Or the rotation will be fucked in iOS 9.
  private var isStatusBarOrientationChanging = false
  
  /// Will not return `rootViewController` while this value is `true`. Needed for iOS 13.
  private var isShowing = false
  
  /// Returns original subviews. `ToastWindow` overrides `addSubview()` to add a subview to the
  /// top window instead itself.
  private var originalSubviews = NSPointerArray.weakObjects()
  
  private weak var mainWindow: UIWindow?
  

  // MARK: - Initializing

  public init(frame: CGRect, mainWindow: UIWindow?) {
    super.init(frame: frame)
    self.mainWindow = mainWindow
    self.isUserInteractionEnabled = false
    self.gestureRecognizers = nil
    self.backgroundColor = .clear
    self.isHidden = false
    self.handleRotate(UIApplication.shared.statusBarOrientation)
    ScreenObserver.shared().delegate = self
  }

  required public init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented: please use ToastWindow.shared")
  }
  
  
  // MARK: - Public method
  
  override open func addSubview(_ view: UIView) {
    super.addSubview(view)
    self.originalSubviews.addPointer(Unmanaged.passUnretained(view).toOpaque())
    self.topWindow()?.addSubview(view)
  }
  
  open override func becomeKey() {
    super.becomeKey()
    mainWindow?.makeKey()
  }
  
  
  // MARK: - Private method

  private func handleRotate(_ orientation: UIInterfaceOrientation) {
    let angle = self.angleForOrientation(orientation)
    if self.shouldRotateManually {
      self.transform = CGAffineTransform(rotationAngle: CGFloat(angle))
    }
    
    if let window = UIApplication.shared.windows.first {
      if orientation.isPortrait || !self.shouldRotateManually {
        self.frame.size.width = window.bounds.size.width
        self.frame.size.height = window.bounds.size.height
      } else {
        self.frame.size.width = window.bounds.size.height
        self.frame.size.height = window.bounds.size.width
      }
    }
    
    self.frame.origin = .zero
    
    DispatchQueue.main.async {
      ToastCenter.default.currentToast?.view.setNeedsLayout()
    }
  }

  private func angleForOrientation(_ orientation: UIInterfaceOrientation) -> Double {
    switch orientation {
    case .landscapeLeft: return -.pi / 2
    case .landscapeRight: return .pi / 2
    case .portraitUpsideDown: return .pi
    default: return 0
    }
  }

  /// Returns top window that isn't self
  private func topWindow() -> UIWindow? {
    if let window = UIApplication.shared.windows.last(where: {
      // https://github.com/devxoul/Toaster/issues/152
      ScreenObserver.shared().didKeyboardShow || $0.isOpaque
    }), window !== self {
      return window
    }
    return nil
  }
  
}

extension ToastWindow: ScreenObserverDelegate {
  
  public func screenObserver(_ screenObserver: ScreenObserver, statusBarOrientationWillChange notification: Notification) {
    self.isStatusBarOrientationChanging = true
  }
  
  public func screenObserver(_ screenObserver: ScreenObserver, statusBarOrientationDidChange notification: Notification) {
    let orientation = UIApplication.shared.statusBarOrientation
    self.handleRotate(orientation)
    self.isStatusBarOrientationChanging = false
  }
  
  public func screenObserver(_ screenObserver: ScreenObserver, applicationDidBecomeActive notification: Notification) {
    let orientation = UIApplication.shared.statusBarOrientation
    self.handleRotate(orientation)
  }
  
  public func screenObserver(_ screenObserver: ScreenObserver, keyboardWillShow notification: Notification) {
    guard let topWindow = self.topWindow(),
      let subviews = self.originalSubviews.allObjects as? [UIView] else { return }
    for subview in subviews {
      topWindow.addSubview(subview)
    }
  }
  
  public func screenObserver(_ screenObserver: ScreenObserver, keyboardDidHide notification: Notification) {
    guard let subviews = self.originalSubviews.allObjects as? [UIView] else { return }
    for subview in subviews {
      super.addSubview(subview)
    }
  }

}
