Pod::Spec.new do |s|
  s.name         = "GetResponseAPI"
  s.version      = "0.0.1"
  s.summary      = "This library is an API wrapper for the GetResponse API v3.0"
  s.description  = <<-DESC
                      GetResponseAPI is an API wrapper for the GetResponse API 3.0 that allows you to use basic API methods such as listning, adding, and removing contacts as well as fetching the list of your campaigns.
                       DESC
  s.author       = { "Maciej Kołek" => "maciej.kolek@getresponse.com" }
  s.homepage     = "https://github.com/GetResponse/iOS-Developer-Kit"
  s.license      = { :type => 'MIT', :file => 'LICENSE.TXT' }
  s.platform     = :ios, '8.2'
  s.ios.deployment_target = '8.2'
  s.source       = { :git => "https://github.com/GetResponse/iOS-Developer-Kit.git", :tag => s.version.to_s }
  s.source_files  = 'GetResponseAPI', 'GetResponseAPI/**/*.{h,m}'
  s.resource_bundles = {
    'GetResponseAPI' => []
  }
  s.requires_arc = true
  s.dependency 'AFNetworking', '~> 2.0'
  s.dependency 'JSONModel', '~> 1.0'
  s.dependency 'AFNetworkActivityLogger'
end