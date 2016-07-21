Pod::Spec.new do |s|
  s.name         = "JLToast"
  s.version      = "1.4.2"
  s.summary      = "Toast UI for Swift - Android-like toast with very simple interface."
  s.homepage     = "http://github.com/devxoul/JLToast"
  s.license      = { :type => 'WTFPL', :file => 'LICENSE' }
  s.author       = { "devxoul" => "devxoul@gmail.com" }
  s.source       = { :git => "https://github.com/devxoul/JLToast.git",
                     :tag => "#{s.version}" }
  s.platform     = :ios, '8.0'
  s.source_files = 'JLToast/*.{swift,h}'
  s.public_header_files = 'JLToast/JLToast.h'
  s.frameworks   = 'UIKit', 'Foundation', 'QuartzCore'
  s.requires_arc = true
end
