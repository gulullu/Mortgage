Pod::Spec.new do |s|
  s.name             = "Mortgage"
  s.version          = "1.0.0"
  s.summary          = "mfb'calculator on iOS."
  s.description      = <<-DESC
                       mfb'calculator for iOS.
                       DESC
  s.homepage         = "http://10.7.0.249/global/ios_calculator"
  # s.screenshots    = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = 'BobAngus'
  s.source           = { :git => "http://10.7.0.249/global/ios_calculator.git", :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/NAME'

  s.platform     = :ios, '7.0'
  # s.ios.deployment_target = '7.0'
  # s.osx.deployment_target = '10.7'
  s.requires_arc = true

  s.source_files = 'Mortgage/Mortgage/MortgageVc/*','Mortgage/Mortgage/MortgageVc/SVProgressHUD/*'
  #s.resources = 'Images.xcassets'

  # s.ios.exclude_files = 'Classes/osx'
  # s.osx.exclude_files = 'Classes/ios'
  # s.public_header_files = 'Classes/**/*.h'
  s.frameworks = 'Foundation', 'CoreGraphics', 'UIKit'

end