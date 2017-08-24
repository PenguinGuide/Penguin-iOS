#
#  Be sure to run `pod spec lint PGAPIClient.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

s.name         = "PGImageView"
s.version      = "1.0"
s.summary      = "PenguinGuide UIImageView category"
s.description  = "PenguinGuide UIImageView category"
s.homepage     = "http://EXAMPLE/PGAlertController"
s.license      = "MIT"
s.author       = { "Kobe Dai" => "kobe.dai@penguinguide.com" }
s.platform     = :ios, "8.0"
s.source       = { :git => "https://github.com/PenguinGuide/Penguin-iOS.git", :tag => "#{s.version}" }

s.public_header_files = "*.h"
s.source_files = "*.{h,m}"

s.dependency "SDWebImage"
s.dependency "FLAnimatedImage"

s.requires_arc = true

end
