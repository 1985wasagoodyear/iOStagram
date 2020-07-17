Pod::Spec.new do |s|  
    s.name              = 'CommonUtility'
    s.version           = '1.0.0'
    s.summary           = 'A bunch of iOS utilities.'
    s.homepage          = 'https://github.com/1985wasagoodyear/iOStagram'

    s.author            = { 'Name' => 'https://github.com/1985wasagoodyear' }
    s.license           = { :type => 'GNU General Public License v3.0', :file => 'LICENSE' }

    s.ios.deployment_target  = '10.0'
    s.source            = { :git => "https://github.com/1985wasagoodyear/iOStagram", :tag => "1.0.0" }
          
    s.exclude_files 	= [
    			'CommonUtility/CommonUtility.xcodeproj'
  			]
    s.source_files     = "CommonUtility/CommonUtility/**/*.{h,m,swift}"
end  
