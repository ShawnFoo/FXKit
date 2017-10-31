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
  spec.framework  = "UIKit"
  spec.requires_arc = true

  spec.subspec 'Util' do |ss|
    ss.source_files = "FXKit/Util/*.{h,m}"
  end

  spec.subspec 'Category' do |ss|
    ss.subspec 'NSPrefix' do |sss|
      sss.source_files = "FXKit/Category/NSPrefix/*.{h,m}"
    end

    ss.subspec 'CAPrefix' do |sss|
      sss.source_files = "FXKit/Category/CAPrefix/*.{h,m}"
    end

    ss.subspec 'UIPrefix' do |sss|
      sss.source_files = "FXKit/Category/UIPrefix/*.{h,m}"
    end
  end

  spec.subspec 'Enhancement' do |ss|
    ss.source_files = "FXKit/Enhancement/*.{h,m}"
  end

end
