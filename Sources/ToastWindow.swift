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
    #if swift(>=4.2)
    self.windowLevel = .init(rawValue: .greatestFiniteMagnitude)
    let willChangeStatusBarOrientationName = UIApplication.willChangeStatusBarOrientationNotification
    let didChangeStatusBarOrientationName = UIApplication.didChangeStatusBarOrientationNotification
    let didBecomeActiveName = UIApplication.didBecomeActiveNotification
    let keyboardWillShowName = UIWindow.keyboardWillShowNotification
    let keyboardDidHideName = UIWindow.keyboardDidHideNotification
    #else
    self.windowLevel = .greatestFiniteMagnitude
    let willChangeStatusBarOrientationName = NSNotification.Name.UIApplicationWillChangeStatusBarOrientation
    let didChangeStatusBarOrientationName = NSNotification.Name.UIApplicationDidChangeStatusBarOrientation
    let didBecomeActiveName = NSNotification.Name.UIApplicationDidBecomeActive
    let keyboardWillShowName = NSNotification.Name.UIKeyboardWillShow
    let keyboardDidHideName = NSNotification.Name.UIKeyboardDidHide
    #endif
    self.backgroundColor = .clear
    self.isHidden = false
    self.handleRotate(UIApplication.shared.statusBarOrientation)

    NotificationCenter.default.addObserver(
      self,
      selector: #selector(self.statusBarOrientationWillChange),
      name: willChangeStatusBarOrientationName,
      object: nil
    )
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(self.statusBarOrientationDidChange),
      name: didChangeStatusBarOrientationName,
      object: nil
    )
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(self.applicationDidBecomeActive),
      name: didBecomeActiveName,
      object: nil
    )
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(self.keyboardWillShow),
      name: keyboardWillShowName,
      object: nil
    )
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(self.keyboardDidHide),
      name: keyboardDidHideName,
      object: nil
    )
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

  @objc private func statusBarOrientationWillChange() {
    self.isStatusBarOrientationChanging = true
  }

  @objc private func statusBarOrientationDidChange() {
    let orientation = UIApplication.shared.statusBarOrientation
    self.handleRotate(orientation)
    self.isStatusBarOrientationChanging = false
  }

  @objc private func applicationDidBecomeActive() {
    let orientation = UIApplication.shared.statusBarOrientation
    self.handleRotate(orientation)
  }

  @objc private func keyboardWillShow() {
    guard let topWindow = self.topWindow(),
      let subviews = self.originalSubviews.allObjects as? [UIView] else { return }
    for subview in subviews {
      topWindow.addSubview(subview)
    }
  }

  @objc private func keyboardDidHide() {
    guard let subviews = self.originalSubviews.allObjects as? [UIView] else { return }
    for subview in subviews {
      super.addSubview(subview)
    }
  }
  
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
      KeyboardObserver.shared.didKeyboardShow || $0.isOpaque
    }), window !== self {
      return window
    }
    return nil
  }
  
}
