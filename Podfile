platform :ios, '8.0'
source 'https://github.com/CocoaPods/Specs.git'
use_frameworks!

target 'SeamlessSlideUpScrollViewDemo' do
    pod 'SeamlessSlideUpScrollView', :path => './'
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['SWIFT_VERSION'] = '2.3'
    end
  end
end
