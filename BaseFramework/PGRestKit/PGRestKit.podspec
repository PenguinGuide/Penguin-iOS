#
#  Be sure to run `pod spec lint PGAPIClient.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

s.name         = "PGRestKit"
s.version      = "1.0"
s.summary      = "PenguinGuide network request mapping framework"
s.description  = "PenguinGuide network request mapping framework"
s.homepage     = "http://EXAMPLE/PGRestKit"
s.license      = "MIT"
s.author       = { "Kobe Dai" => "kobe.dai@penguinguide.com" }
s.platform     = :ios, "8.0"
s.source       = { :git => "https://github.com/PenguinGuide/Penguin-iOS.git", :tag => "#{s.version}" }

s.public_header_files = "*.h", "Network/*.h", "ModelMapping/*.h", "Support/*.h"
s.source_files = "*.{h,m}", 'Network/*.{h,m}', "ModelMapping/*.{h,m}", "Support/*.{h,m}"

s.subspec 'Support'  do |sp|
sp.source_files = 'Support/SOCKit.{h,m}'
sp.requires_arc = false
end

s.dependency "Mantle", "2.0.7"
s.dependency "AFNetworking", "3.1.0"
s.dependency "OHHTTPStubs", "5.1.0"

s.requires_arc = true

end
