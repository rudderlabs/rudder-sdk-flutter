Pod::Spec.new do |s|
  s.name             = 'rudder_sdk_flutter'
  s.version          = '0.0.1'
  s.summary          = 'RudderStack flutter SDK ios plugin project'
  s.description      = <<-DESC
RudderStack flutter SDK ios plugin project
                       DESC
  s.homepage         = 'https://rudderstack.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Sai Venkat Desu' => 'venkat@rudderstack.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'
  s.platform = :ios, '8.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
end
