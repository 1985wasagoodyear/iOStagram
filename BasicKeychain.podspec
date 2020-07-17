Pod::Spec.new do |s|  
    s.name              = 'BasicKeychain'
    s.version           = '1.0.0'
    s.summary           = 'A simple wrapper using the Generic Keychain from Apple'
    s.homepage          = 'https://github.com/1985wasagoodyear/iOStagram'

    s.author            = { 'Name' => 'https://github.com/1985wasagoodyear' }
    s.license           = { :type => 'GNU General Public License v3.0', :file => 'LICENSE' }

    s.source            = { :git => "https://github.com/1985wasagoodyear/iOStagram", :tag => "1.0.0" }

    s.ios.deployment_target  = '8.0'
    s.exclude_files 	= [
    			'BasicKeychain/BasicKeychain.xcodeproj'
  			]
          
    s.source_files     = "BasicKeychain/BasicKeychain/**/*.{h,m,swift}"

end  
