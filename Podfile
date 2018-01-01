platform :ios, '8.0'
target 'FXKitDemo' do
  # pod 'FXKit', git: 'https://github.com/ShawnFoo/FXKit.git', branch: '0.1'
  pod 'FXKit', :path => '../FXKit'
  post_install do |installer|
    installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings['ENABLE_BITCODE'] = 'YES'
        config.build_settings['CLANG_ALLOW_NON_MODULAR_INCLUDES_IN_FRAMEWORK_MODULES'] = 'YES'
      end
    end
  end

  target 'FXKitDemoTests' do
    inherit! :search_paths
  end
end
