#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint rudder_integration_firebase_flutter.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'rudder_integration_firebase_flutter'
  s.version          = '2.0.0'
  s.summary          = "RudderStack's Flutter Device Mode for the Firebase Destination"
  s.description      = <<-DESC
  Rudder is a platform for collecting, storing and routing customer event data to dozens of tools. Rudder is open-source, can run in your cloud environment (AWS, GCP, Azure or even your data-centre) and provides a powerful transformation framework to process your event data on the fly.
                       DESC
  s.homepage         = 'https://github.com/rudderlabs/rudder-sdk-flutter/tree/main/packages/integrations'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'RudderStack' => 'sdk@rudderstack.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  
  s.ios.deployment_target = '11.0'

  s.dependency 'Flutter'
  s.dependency 'rudder_plugin_ios'
  s.dependency 'Rudder-Firebase', '3.0.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
end
