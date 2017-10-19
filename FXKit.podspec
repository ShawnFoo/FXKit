Pod::Spec.new do |spec|
  spec.name         = "FXKit"
  spec.version      = "0.0.1"
  spec.summary      = "Encapsulation of convenient utils."

  spec.homepage     = "https://github.com/ShawnFoo/FXKit"
  spec.license      = { :type => "MIT", :file => "LICENSE" }

  spec.author             = { "Shawn Foo" => "fu4904@gmail.com" }
  spec.platform     = :ios
  spec.ios.deployment_target = "8.0"

  spec.source       = { :git => "https://github.com/ShawnFoo/FXKit.git", :tag => "v#{spec.version.to_s}" }
  #spec.source_files  = "FXKit/*.{h,m}"
  spec.framework  = "UIKit"
  spec.requires_arc = true

  spec.subspec 'Util' do |util|
    util.source_files = "FXKit/Util/*.{h,m}"
  end

end
