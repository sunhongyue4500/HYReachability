#
# Be sure to run `pod lib lint HYReachability.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'HYReachability'
  s.version          = '0.1.1'
  s.summary          = 'HYReachability'
  s.description      = 'HYReachability, Wrapper of Reachability(Tony Million)'
  s.homepage         = 'https://github.com/sunhongyue4500/HYReachability'
  s.license          = 'MIT'
  s.author           = { "hongyi" => "sunhongyue4500@gmail.com" }
  s.source           = { :git => "https://github.com/sunhongyue4500/HYReachability.git", :tag => s.version.to_s }
  s.platform     = :ios, '8.0'
  s.ios.deployment_target = '8.0'
  s.requires_arc = true
  s.source_files = 'HYReachability'
  s.dependency 'Reachability', '~> 3.2'

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'

end
