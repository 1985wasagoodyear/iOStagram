Pod::Spec.new do |s|  
    s.name              = 'CommonUIUtilities'
    s.version           = '1.0.0'
    s.summary           = 'A bunch of iOS utilities, for UI.'
    s.homepage          = 'https://github.com/1985wasagoodyear/iOStagram'

    s.author            = { 'Name' => 'https://github.com/1985wasagoodyear' }
    s.license           = { :type => 'GNU General Public License v3.0', :file => 'LICENSE' }

    s.platform          = :ios

    s.ios.deployment_target  = '10.0'
    s.source            = { :git => "https://github.com/1985wasagoodyear/iOStagram", :tag => "1.0.0" }
    s.source_files     = "CommonUIUtilities/CommonUIUtilities/**/*.{h,m,swift}"
    s.exclude_files 	= [
    			'CommonUIUtilities/CommonUIUtilities.xcodeproj'
  			]
    s.dependency 'CommonUtility'
end  
