#
# Be sure to run `pod lib lint HMTextView.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'HMTextView'
  s.version          = '0.1.0'
  s.summary          = 'HMTextView is a configurable textview which can detect and link @ and #.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
'HMTextView is a configurable textview which can detect and link @ and #. You can just set your class to HMTextView and start using it with default values. Also you can udpate text attributes, link text attributes and link fonts.'
                       DESC

  s.homepage         = 'https://github.com/gokhanmandaci/HMTextView'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'gokhanmandaci' => 'gokhanmandaci@gmail.com' }
  s.source           = { :git => 'https://github.com/gokhanmandaci/HMTextView.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/gokhanmandaci'

  s.ios.deployment_target = '11.0'
  
  s.source_files = 'Source/**/*'
  s.swift_version = '5.0'

  
  # s.resource_bundles = {
  #   'HMTextView' => ['HMTextView/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
