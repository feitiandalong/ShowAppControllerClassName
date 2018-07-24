Pod::Spec.new do |s|
s.name = 'ShowAppControllerClassName'
s.version = '1.0.0'
s.license = 'MIT'
s.summary = '显示当前controller的名字'
s.homepage = 'https://github.com/feitiandalong/ShowAppControllerClassName'
s.authors = { 'feitiandalong' => 'cangsangzhinian@qq.com' }
s.source = { :git => "https://github.com/feitiandalong/ShowAppControllerClassName.git", :tag => "1.0.0"}
s.requires_arc = true
s.ios.deployment_target = '8.0'

#你的SDK路径
s.vendored_frameworks = 'ShowAppControllerClassName.framework'

#需要包含的源文件
s.source_files = 'ShowAppControllerClassName.framework/Headers/*.{h}'

#SDK头文件路径
s.public_header_files = 'ShowAppControllerClassName.framework/Headers/ShowAppControllerClassName.h'

#依赖库
s.frameworks   = 'UIKit','Foundation'

end
