# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'WeatherApp' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!
  pod 'RxSwift'
  pod 'RxCocoa'
  pod 'Moya/RxSwift'
  pod 'Kingfisher'
  pod 'RxKingfisher'

    post_install do |installer|
       installer.pods_project.targets.each do |target|
          if target.name == 'RxSwift'
             target.build_configurations.each do |config|
                if config.name == 'Debug'
                   config.build_settings['OTHER_SWIFT_FLAGS'] ||= ['-D', 'TRACE_RESOURCES']
                end
             end
          end
       end
    end

  target 'WeatherAppTests' do
    inherit! :search_paths
    # Pods for testing
    pod 'RxTest'
    pod 'RxBlocking'
    pod 'Nimble'
  end
  
end
