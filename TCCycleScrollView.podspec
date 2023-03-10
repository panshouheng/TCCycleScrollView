#
# Be sure to run `pod lib lint TCCycleScrollView.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'TCCycleScrollView'
  s.version          = '0.1.0
  '
  s.summary          = '轮播组件'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
  仿照SDCycleScrollView进行更改的轮播图，可自定义PageControl
                       DESC

  s.homepage         = 'https://github.com/panshouheng/TCCycleScrollView'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'panshouheng' => 'shouheng.pan@tineco.com' }
  s.source           = { :git => 'https://github.com/panshouheng/TCCycleScrollView.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '11.0'

  s.source_files = 'TCCycleScrollView/Classes/**/*'
  s.dependency 'Masonry'
  s.dependency 'SDWebImage'
end
