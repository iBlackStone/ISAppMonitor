#
# Be sure to run `pod lib lint AppMonitor.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'ISAppMonitor'
  s.version          = '0.2.1'
  s.summary          = '性能监测及缓存工具。'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
1.提供CPU性能监测功能。
2.提供App卡顿监控功能。
3.提供App方法调用耗时功能。
4.所有日志均提供本地缓存功能。
                       DESC

  s.homepage         = 'https://github.com/iBlackStone/AppMonitor'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'iBlackStone' => 'gao375976821@gmail.com' }
  s.source           = { :git => 'https://github.com/iBlackStone/AppMonitor.git', :tag => s.version.to_s }

  s.ios.deployment_target = '9.0'
  
  s.subspec 'Core' do |sp|
      sp.source_files = 'ISAppMonitor/Classes/Core/*.{h,m}'
      
      sp.dependency 'ISAppMonitor/Database'
      sp.dependency 'ISAppMonitor/Model'
      sp.dependency 'ISAppMonitor/Utils'
  end
  s.subspec 'Database' do |sp|
      sp.source_files = 'ISAppMonitor/Classes/Database/*'
      
      sp.dependency 'ISAppMonitor/Model'
  end
  s.subspec 'Model' do |sp|
      sp.source_files = 'ISAppMonitor/Classes/Model/*'
  end
  s.subspec 'Utils' do |sp|
      sp.source_files = 'ISAppMonitor/Classes/Utils/*'
      
      sp.dependency 'ISAppMonitor/Model'
  end
  
  # s.resource_bundles = {
  #   'AppMonitor' => ['AppMonitor/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'UIKit'
  s.dependency 'AFNetworking'
  s.dependency 'FMDB'
end
