import UIKit
import Toaster
import Photos

final class RootViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    
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

    let imagePickerButton = UIButton(type: .system)
    imagePickerButton.setTitle("Open imagePicker", for: .normal)
    imagePickerButton.sizeToFit()
    imagePickerButton.addTarget(self, action: #selector(self.imagePickerButtonTouchUpInside), for: .touchUpInside)
    imagePickerButton.autoresizingMask = [.flexibleBottomMargin, .flexibleLeftMargin, .flexibleRightMargin]
    imagePickerButton.center = CGPoint(x: view.center.x, y: 155)
    self.view.addSubview(imagePickerButton)
    
    let shadowButton = UIButton(type: .system)
    shadowButton.setTitle("Toggle shadow", for: .normal)
    shadowButton.sizeToFit()
    shadowButton.addTarget(self, action: #selector(self.shadowButtonTouchUpInside), for: .touchUpInside)
    shadowButton.autoresizingMask = [.flexibleBottomMargin, .flexibleLeftMargin, .flexibleRightMargin]
    shadowButton.center = CGPoint(x: view.center.x, y: 185)
    self.view.addSubview(shadowButton)

    self.configureAppearance()
    self.configureAccessibility()
  }

  func configureAppearance() {
    let appearance = ToastView.appearance()
    appearance.backgroundColor = .lightGray
    appearance.textColor = .black
    appearance.font = .boldSystemFont(ofSize: 16)
    appearance.textInsets = UIEdgeInsets(top: 15, left: 20, bottom: 15, right: 20)
    appearance.bottomOffsetPortrait = 100
    appearance.cornerRadius = 20
    appearance.maxWidthRatio = 0.7
  }

  func configureAccessibility() {
    ToastCenter.default.isSupportAccessibility = true
  }

  @objc dynamic func showButtonTouchUpInside() {
    Toast(text: "Basic Toast").show()
    Toast(attributedText: NSAttributedString(string: "AttributedString Toast", attributes: [NSAttributedString.Key.backgroundColor: UIColor.yellow])).show()
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

  @objc dynamic func imagePickerButtonTouchUpInside(sender: UIButton) {
    pickImage()
  }
  
  @objc dynamic func shadowButtonTouchUpInside(sender: UIButton) {
    let appearance = ToastView.appearance()
    if appearance.shadowColor == nil {
      appearance.shadowColor = .black
      appearance.shadowOpacity = 0.2
      appearance.shadowOffset = CGSize(width: 0, height: 1)
      appearance.shadowRadius = 10
    } else {
      appearance.shadowColor = nil
      appearance.shadowOpacity = 0
      appearance.shadowOffset = .zero
      appearance.shadowRadius = 0
    }
  }

  private func pickImage() {
    let authorizationStatus = PHPhotoLibrary.authorizationStatus()
    if authorizationStatus == .denied {
      print("You didn't grant photo album permission. Please check your settings.")
      return
    } else if authorizationStatus == .notDetermined {
      // prompt the user about permissions before opening photo album
      if #available(iOS 11.0, *) {
        // nothing to do: no permission request needed on iOS 11+
      } else {
        PHPhotoLibrary.requestAuthorization { success in
          if success == .authorized {
            DispatchQueue.main.async {
              self.pickImage()
            }
          }
        }
        return
      }
    }
    let mediaPicker = UIImagePickerController()
    mediaPicker.delegate = self
    present(mediaPicker, animated: true, completion: nil)
  }
}

extension RootViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    Toast(text: "Hello, Great image.").show()
    picker.dismiss(animated: true, completion: nil)
  }

  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    picker.dismiss(animated: true) {
      print("User cancelled")
    }
  }
}

class RespondingButton: UIButton, UIKeyInput {
  override var canBecomeFirstResponder: Bool {
    return true
  }
  var hasText: Bool = true
  var autocorrectionType: UITextAutocorrectionType = .no
  func insertText(_ text: String) {}
  func deleteBackward() {}
}
