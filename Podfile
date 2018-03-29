use_frameworks!
#platform :osx
inhibit_all_warnings! #屏蔽所有warning

target 'MogoAirport' do

  pod 'RxSwift'
  pod 'RxCocoa'
  pod 'RealmSwift'
  pod 'GRMustache.swift'
  pod 'SnapKit'
  pod 'ITProgressBar'
  pod 'Yaml'
  pod 'Stencil', '>= 0.8.0'
  pod 'PathKit'

  target 'MogoAirportTests' do

    inherit! :search_paths

    pod 'Quick'
    pod 'Nimble'
  end

  post_install do |installer|
    # 需要指定编译版本的第三方的名称
    myTargets = ['GRMustache.swift', 'Stencil']

    installer.pods_project.targets.each do |target|
        if myTargets.include? target.name
            target.build_configurations.each do |config|
                config.build_settings['SWIFT_VERSION'] = '3.2'
            end
        end
    end
  end

end
