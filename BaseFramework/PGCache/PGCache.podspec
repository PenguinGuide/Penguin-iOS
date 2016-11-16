#
#  Be sure to run `pod spec lint PGCache.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

s.name         = "PGCache"
s.version      = "1.0"
s.summary      = "PenguinGuide cache manager"
s.description  = "PenguinGuide cache manager"
s.homepage     = "http://EXAMPLE/PGCache"
s.license      = "MIT"
s.author       = { "Kobe Dai" => "kobe.dai@penguinguide.com" }
s.platform     = :ios, "8.0"
s.source       = { :git => "https://github.com/PenguinGuide/Penguin-iOS.git", :tag => "#{s.version}" }

s.public_header_files = "*.h"
s.source_files = "*.{h,m}"

s.dependency 'FMDB'

end
