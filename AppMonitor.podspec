#
# Be sure to run `pod lib lint AppMonitor.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'AppMonitor'
  s.version          = '0.1.1'
  s.summary          = '集成有关App的性能监控功能'

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
  
  s.source_files = 'AppMonitor/Classes/*.{h,m}'
  s.subspec 'Core' do |sp|
      sp.source_files = 'AppMonitor/Classes/Core/*.{h,m}'
  end
  s.subspec 'Database' do |sp|
      sp.source_files = 'AppMonitor/Classes/Database/*'
  end
  s.subspec 'Model' do |sp|
      sp.source_files = 'AppMonitor/Classes/Model/*'
  end
  s.subspec 'Utils' do |sp|
      sp.source_files = 'AppMonitor/Classes/Utils/*'
  end
  
  # s.resource_bundles = {
  #   'AppMonitor' => ['AppMonitor/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'UIKit', 'MapKit'
  s.dependency 'AFNetworking', '~> 3.1.0'
  s.dependency 'FMDB', '~> 2.6.2'
end
