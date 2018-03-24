Pod::Spec.new do |s|
  s.name         = "CTFeedbackSwift"
  s.version      = "0.1.4"
  s.summary      = "Feedback composer for iOS"
  s.homepage     = "https://github.com/rizumita/CTFeedbackSwift"
  s.screenshots  = "https://github.com/rizumita/CTFeedbackSwift/raw/master/CTFeedbackSwift.png"
  s.license      = "MIT"
  s.author             = { "Ryoichi Izumita" => "r.izumita@caph.jp" }
  s.social_media_url   = "http://twitter.com/rizumita"
  s.platform     = :ios, "9.0"
  s.source       = { :git => "https://github.com/rizumita/CTFeedbackSwift.git", :tag => "v#{s.version}" }
  s.source_files  = "CTFeedbackSwift", "CTFeedbackSwift/**/*.{h,m,swift}"
  s.resources = ["CTFeedbackSwift/Resources/*.lproj", "CTFeedbackSwift/Resources/PlatformNames.plist"]
  s.framework  = 'MessageUI'
end
