Pod::Spec.new do |s|
  s.name             = "GooglePlacesAPI"
  s.version          = "1.1.4"
  s.summary          = "Swift Wrapper on Google Places API"
  s.description      = <<-DESC
                       Swift Wrapper on Google Places API
                       https://developers.google.com/places/web-service/

                       DESC
  s.homepage         = "https://github.com/honghaoz/Swift-Google-Maps-API"
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { "Honghao Zhang" => "zhh358@gmail.com" }
  s.source           = { :git => "https://github.com/honghaoz/Swift-Google-Maps-API.git", :tag => s.version.to_s }

  s.ios.deployment_target = "8.0"
  s.osx.deployment_target = "10.10"
  s.watchos.deployment_target = "2.0"
  s.tvos.deployment_target = "9.0"

  s.requires_arc     = true
  s.source_files     = "Source/GooglePlacesAPI/Core/**/*.*", "Source/GooglePlacesAPI/**/*.*"
  s.module_name      = "GooglePlacesAPI"

  s.dependency 'Alamofire', '~> 4'
  s.dependency 'ObjectMapper', '~> 4'

end
