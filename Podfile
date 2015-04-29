platform :ios, '7.0'
xcodeproj 'PWLMSample.xcodeproj'

target :PWLMSample, :exclusive => true do
    pod 'MBProgressHUD'
    
    pod 'PW_Shared'
    pod 'PWCore'
    pod 'AFNetworking'
    pod 'FMDB/SQLCipher'
    pod 'PWLogger', :git => 'https://github.com/phunware/sdk-ios-logger.git', :branch => 'master'
end

target :PWLMSampleTests, :exclusive => true do
  pod 'Kiwi'
  pod 'OHHTTPStubs'
  pod 'RPJSONValidator'
  pod 'PWCore'
  pod 'Leech', :git => 'https://github.com/samodom/Leech', :branch => 'sam'
end

post_install do |installer_representation|
  installer_representation.project.targets.each do |target|
    if target.name == "Pods-PWLocalpoint-PWLogger"
      target.build_configurations.each do |config|
        if config.name == 'Development'
          config.build_settings['GCC_PREPROCESSOR_DEFINITIONS'] ||= ['$(inherited)', 'PWLOGGER_LOG_INTERNAL_INFORMATION=1']
        end
      end
    end
  end
end