Pod::Spec.new do |s|
  s.name     = 'TableViewAgent'
  s.version  = '0.1.1'
  s.license  = 'MIT'
  s.summary  = 'Wrapper class of UITableViewDelegate'
  s.homepage = 'http://d.hatena.ne.jp/akuraru/'
  s.author   = { 'Akuraru IP' => 'akuraru@gmail.com' }
  s.source   = { :git => 'https://github.com/akuraru/TableViewAgent.git' }
  s.platform = :ios  
  s.source_files = 'TableViewAgent/**/*.{h,m}'
  s.requires_arc = true
  s.framework = 'UIKit'
end
