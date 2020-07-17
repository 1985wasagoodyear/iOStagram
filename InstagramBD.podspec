Pod::Spec.new do |s|  
    s.name              = 'InstagramBD'
    s.version           = '1.0.0'
    s.summary           = 'A simple wrapper for Instagram Graph API and Instagram Basic Display APIs'
    s.homepage          = 'https://github.com/1985wasagoodyear/iOStagram'

    s.author            = { 'Name' => 'https://github.com/1985wasagoodyear' }
    s.license           = { :type => 'GNU General Public License v3.0', :file => 'LICENSE' }

    s.platform          = :ios
    s.source            = { :git => "https://github.com/1985wasagoodyear/iOStagram", :tag => "1.0.0" }
          
    s.source_files     = "BasicKeychain/**/*.{h,m,swift}", "CommonUtility/**/*.{h,m,swift}", "InstagramBD/**/*.{h,m,swift}"

end  
