#
# Be sure to run `pod lib lint MapDoodle.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'MapDoodle'
  s.version          = '0.0.2'
  s.summary          = 'iOS library to create common map animations'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/vornet/mapdoodle-ios'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Vorn Mom' => 'vorn@vorn.us' }
  s.source           = { :git => 'https://github.com/vornet/mapdoodle-ios.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/vornet'

  s.ios.deployment_target = '9.0'

  s.source_files = 'MapDoodle/Classes/**/*'
  
  # s.resource_bundles = {
  #   'MapDoodle' => ['MapDoodle/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
