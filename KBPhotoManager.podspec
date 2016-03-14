Pod::Spec.new do |s|
s.name         = "KBPhotoManager"
s.version      = "1.0"
s.summary      = "Photo manager to fetch all photo ALAssets and PHAssets for iOS 7, 8 and 9"
s.homepage     = "https://github.com/dai-jing/KBPhotoManager"
s.license      = { :type => 'MIT', :file => 'LICENSE' }
s.author       = { "Jing Dai" => "daijing24@gmail.com" }
s.platform     = :ios
s.platform   	 = :ios, "7.0"
s.requires_arc = true
s.source       = {
:git => "https://github.com/dai-jing/KBPhotoManager.git",
:branch => "master",
:tag => s.version.to_s
}
s.source_files = "*.{h,m}"
s.public_header_files = "*.h"
end