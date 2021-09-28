Pod::Spec.new do |s|
  s.name             = 'MoyasarSdk'
  s.version          = '0.1.0'
  s.summary          = 'Moyasar iOS SDK'

  s.description      = <<-DESC
  Easily add payment processing to your app with Moyasar iOS SDK
  DESC

  s.homepage         = 'https://github.com/moyasar/moyasar-ios-sdk'
  s.license          = { type: 'MIT', file: 'LICENSE' }
  s.author           = {
    'Moyasar Developers' => 'developers@moyasar.com',
    'Ali Alhoshaiyan' => 'ahoshaiyan@fastmail.com'
  }

  s.source = { git: 'git@github.com:ahoshaiyan/moyasar-ios-sdk.git', branch: 'implement-credit-card' }

  s.swift_version = '5.0'
  s.platform = :ios
  s.ios.deployment_target = '13.0'

  s.source_files = [
    'MoyasarSdk/Errors/**/*',
    'MoyasarSdk/Helpers/**/*',
    'MoyasarSdk/Models/**/*',
    'MoyasarSdk/Services/**/*',
    'MoyasarSdk/Views/**/*'
  ]

  s.resource_bundles = {
    'com.moyasar.MoyasarSdk' => [
      'MoyasarSdk/**/*.{xcassets,lproj}'
    ]
  }
end
