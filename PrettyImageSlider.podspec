#
# Be sure to run `pod lib lint PrettyImageSlider.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'PrettyImageSlider'
  s.version          = '0.3'
  s.summary          = 'Image slider with thin page control'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
  Image slider with title, decription and thin page control.
  You can dinamicly change font, size and weight of image title and description from code and storyboard.
                       DESC

  s.homepage         = 'https://github.com/Madara2hor/PrettyImageSlider'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Madara2hor' => 'Kkprokk07@gmail.com' }
  s.source           = { :git => 'https://github.com/Madara2hor/PrettyImageSlider', :tag => s.version.to_s }

  s.ios.deployment_target = '12.1'
  s.swift_version = '5.0'

  s.source_files = 'PrettyImageSlider/Source/**/*'
  
  #s.resource_bundles = {
  #  'PrettyImageSlider' => ['PrettyImageSlider/Assets/*.jpg']
  #}

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
