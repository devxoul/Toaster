Pod::Spec.new do |s|
  s.name         = 'Toaster'
  s.version      = '2.3.0'
  s.summary      = 'Toast in Swift for iOS'
  s.description  = 'Toast in Swift for iOS, with support for Queueing, Customization, String/NSAttributedString, UIAccessibility, Swift/Objective-C and more.'
  s.homepage     = 'https://github.com/devxoul/Toaster'
  s.license      = { :type => 'WTPFL', :file => 'LICENSE' }
  s.author       = { 'devxoul' => 'devxoul@gmail.com' }
  s.source       = { :git => 'https://github.com/devxoul/Toaster.git',
                     :tag => "#{s.version}" }
  s.platform     = :ios, '9.0'
  s.source_files = 'Sources/*.{swift,h}'
  s.frameworks   = 'UIKit', 'Foundation', 'QuartzCore'
  s.swift_version = '5.0'
end
