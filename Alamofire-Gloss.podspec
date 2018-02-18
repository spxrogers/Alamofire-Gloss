Pod::Spec.new do |s|
  s.name             = "Alamofire-Gloss"
  s.version          = "3.0.1"
  s.summary          = "Convenience Gloss bindings for Alamofire."
  s.description      = <<-EOS
    [Gloss](https://github.com/hkellaway/Gloss) bindings for
    [Alamofire](https://github.com/Alamofire/Alamofire) for easy-peasy JSON serialization.
    Instructions on how to use it are in
    [the README](https://github.com/spxrogers/Alamofire-Gloss).
  EOS

  s.homepage         = "https://github.com/spxrogers/Alamofire-Gloss"
  s.license          = { :type => "MIT", :file => "LICENSE" }
  s.author           = { "steven sogers" => "me@srogers.net" }
  s.source           = { :git => "https://github.com/spxrogers/Alamofire-Gloss.git", :tag => s.version.to_s }
  s.social_media_url = "https://twitter.com/spxrogers"

  s.ios.deployment_target = '8.0'
  s.osx.deployment_target = '10.10'
  s.tvos.deployment_target = '9.0'
  s.watchos.deployment_target = '2.0'
  s.requires_arc = true

  s.default_subspec = "Core"

  s.subspec "Core" do |ss|
    ss.source_files  = "Source/*.swift"
    ss.dependency "Alamofire", "~> 4.6.0"
    ss.dependency "Gloss", "~> 2.0.0-beta.2"
    ss.framework  = "Foundation"
  end

end
