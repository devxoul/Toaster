import UIKit
import Toaster

final class RootViewController: UIViewController {

  override func viewDidLoad() {
    let button = UIButton(type: .system)
    button.setTitle("Show", for: .normal)
    button.sizeToFit()
    button.addTarget(self, action: #selector(self.showButtonTouchUpInside), for: .touchUpInside)
    button.autoresizingMask = [.flexibleBottomMargin, .flexibleLeftMargin, .flexibleRightMargin]
    button.center = CGPoint(x: view.center.x, y: 75)
    self.view.addSubview(button)

    let keyboardButton = RespondingButton(type: .system)
    keyboardButton.setTitle("Toggle keyboard", for: .normal)
    keyboardButton.sizeToFit()
    keyboardButton.addTarget(self, action: #selector(self.keyboardButtonTouchUpInside), for: .touchUpInside)
    keyboardButton.autoresizingMask = [.flexibleBottomMargin, .flexibleLeftMargin, .flexibleRightMargin]
    keyboardButton.center = CGPoint(x: view.center.x, y: 125)
    self.view.addSubview(keyboardButton)

    self.configureAppearance()
  }

  func configureAppearance() {
    let appearance = ToastView.appearance()
    appearance.backgroundColor = .lightGray
    appearance.textColor = .black
    appearance.font = .boldSystemFont(ofSize: 16)
    appearance.textInsets = UIEdgeInsets(top: 15, left: 20, bottom: 15, right: 20)
    appearance.bottomOffsetPortrait = 100
    appearance.cornerRadius = 20
  }

  @objc dynamic func showButtonTouchUpInside() {
    Toast(text: "Basic Toast").show()
    Toast(text: "You can set duration. `Delay.short` means 2 seconds.\n" +
      "`Delay.long` means 3.5 seconds.",
          duration: Delay.long).show()
    Toast(text: "With delay, Toaster will be shown after delay.", delay: 1, duration: 5).show()
  }

  @objc dynamic func keyboardButtonTouchUpInside(sender: RespondingButton) {
    if sender.isFirstResponder {
      sender.resignFirstResponder()
    } else {
      sender.becomeFirstResponder()
    }
  }
}

class RespondingButton: UIButton, UIKeyInput {
  override var canBecomeFirstResponder: Bool {
    return true
  }
  var hasText: Bool = true
  func insertText(_ text: String) {}
  func deleteBackward() {}
}
