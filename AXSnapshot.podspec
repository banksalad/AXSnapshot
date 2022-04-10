Pod::Spec.new do |s|
  s.name             = 'AXSnapshot'
  s.version          = '1.0.1'
  s.summary          = 'Text Formatted Snapshot for Accessibility Experience Testing'
  s.swift_versions   = '5.0.0'

  s.description      = <<-DESC
Accessibility User Experience is the sweetest spot for unit testing. 
AXSnapshot makes it super easy to test just that.
                       DESC

  s.homepage         = 'https://github.com/e-sung/AXSnapshot'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'e-sung' => 'dev.esung@gmail.com' }
  s.source           = { :git => 'https://github.com/banksalad/AXSnapshot.git', :tag => "v1.0.1" }

  s.ios.deployment_target = '9.0'
  s.source_files = 'Sources/AXSnapshot/*'

  s.frameworks = 'UIKit'
end
