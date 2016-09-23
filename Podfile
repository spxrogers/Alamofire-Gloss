post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '2.3'
        end
    end
end

target ‘AlamofireGloss’ do
    use_frameworks!
    pod 'Gloss', '~> 0.8'
    pod 'Alamofire'
end
