//
//  UIApplication+Load.swift
//  Toaster
//
//  Created by SeongHo Hong on 28/08/2019.
//  Copyright © 2019 Suyeol Jeon. All rights reserved.
//

import UIKit

extension UIApplication {
  
  open override var next: UIResponder? {
    UIApplication.runOnce
    return super.next
  }
  
  private static let runOnce: Void = {
    _ = KeyboardObserver.shared
  }()
  
}
