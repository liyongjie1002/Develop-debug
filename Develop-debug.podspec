
Pod::Spec.new do |s|
  s.name             = 'Develop-debug'
  s.version          = '1.0.2'
  s.summary          = 'debug模式的依赖'

 
  s.description      = <<-DESC
    打包的时候不会被打包到IPA
                       DESC

  s.homepage         = 'https://github.com/Iyongjie/Develop-debug.git'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'iyongjie@yeah.net' => 'yj.li@muheda.com' }
  s.source           = { :git => 'https://github.com/Iyongjie/Develop-debug.git', :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'

  s.source_files = 'Develop-debug/MDDebugManager/*.{h,m}', 'Develop-debug/BLStopwatch/*.{h,m}'

  s.dependency 'YYKit-used'
  s.dependency 'FBMemoryProfiler'
  s.dependency 'OCMock'

end
