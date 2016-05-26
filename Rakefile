# -*- coding: utf-8 -*-
$:.unshift("/Library/RubyMotion/lib")
require 'motion/project/template/ios'
require 'teacup'
require 'sugarcube'
require 'bubble-wrap/core'
require 'bubble-wrap/http'

Motion::Project::App.setup do |app|
  # Use `rake config' to see complete project settings.
  app.name = 'Zappea'
  app.entitlements['keychain-access-groups'] = [
    app.seed_id + '.' + app.identifier
  ]
  app.vendor_project('vendor/HMACSHA1', :xcode, headers_dir: 'HMACSHA1')
  app.vendor_project('vendor/Keychain', :xcode, headers_dir: 'Keychain')
  app.detect_dependencies = false

  app.files.unshift('./app/twitter/twitter.rb') 
  app.files.unshift('./app/twitter/oauth.rb') 
  app.files.unshift('./app/twitter/http.rb') 
  app.files.unshift('./app/helpers/helper.rb') 
  #app.files.unshift('./app/twitter/key.rb')
  app.files.unshift('./app/helpers/constant.rb')
  app.files.unshift('./app/helpers/provider.rb') #
  
  app.version = '1.2.0'
  app.info_plist['CFBundleShortVersionString'] = '1.2.0'
  app.deployment_target = '4.3'
  app.interface_orientations = [:portrait]
  app.icons = Dir.glob("resources/icon*.png").map{|icon| icon.split("/").last}
  app.prerendered_icon = true
  # App Store
  #app.identifier = 'com.zappea.zappeatv'
  #app.codesign_certificate = 'iPhone Distribution: RODRIGO CERECEDA (3546Q4N4Q8)'
  #app.provisioning_profile = '/Users/rodrigocerecedagrunert/Library/MobileDevice/Provisioning Profiles/F868CB09-36A8-499C-AB3D-02FB08CD8BE6.mobileprovision'
end
