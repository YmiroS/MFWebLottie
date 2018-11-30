Pod::Spec.new do |s|
  s.name             = 'MFWebLottie'
  s.version          = '1.1.1'
  s.summary          = 'Load the network resources of Lottie'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
Load the network resources of Lottie. Cache
                       DESC

  s.homepage         = 'https://github.com/YmiroS/MFWebLottie.git'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'MeetFresh' => 'yangshuo_2312@163.com' }
  s.source           = { :git => 'https://github.com/YmiroS/MFWebLottie.git', :tag => s.version.to_s }

  s.source_files = 'MFWebLottie/**/*'
  s.requires_arc = true # 是否启用ARC 
  s.platform = :ios, "9.0" #平台及支持的最低版本 # 
  s.frameworks = "UIKit","Foundation" #支持的框架 # 

  # s.resource_bundles = {
  #   'MFWebLottie' => ['MFWebLottie/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
