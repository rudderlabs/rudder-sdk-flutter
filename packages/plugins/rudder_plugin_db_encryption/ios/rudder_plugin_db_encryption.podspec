#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint rudder_plugin_db_encryption.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'rudder_plugin_db_encryption'
  s.version          = '1.0.0'
  s.summary          = 'iOS Module of the RudderStack SDK for Flutter, to enable database encryption.'
  s.description      = <<-DESC
                        This module enables database encryption for the RudderStack SDK for Flutter.
                       DESC
  s.homepage         = 'https://github.com/rudderlabs/rudder-sdk-flutter'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'RudderStack' => 'sdk-accounts@rudderstack.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'
  s.dependency 'rudder_plugin_ios'
  s.dependency 'Rudder'
  s.dependency 'RudderDatabaseEncryption', '~> 1.0.0'
  s.platform = :ios, '11.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
end
