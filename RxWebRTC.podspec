Pod::Spec.new do |s|
  s.name             = 'RxWebRTC'
  s.version          = '0.2.0'
  s.summary          = 'A lightweight RxSwift extension for WebRTC.'
  s.homepage         = 'https://github.com/xquezme/RxWebRTC'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Pimenov Sergey' => 'pimenov.sergei@gmail.com' }
  s.source           = { :git => 'https://github.com/xquezme/RxWebRTC.git', :tag => s.version.to_s }

  s.ios.deployment_target = '9.0'
  s.swift_version = '4.1'

  s.frameworks = 'Foundation', 'AVFoundation'
  s.source_files = 'RxWebRTC/Classes/**/*'

  s.dependency 'GoogleWebRTC', '~> 1.1.23094'
  s.dependency 'RxSwift', '~> 4'
  s.dependency 'RxCocoa', '~> 4'
end
