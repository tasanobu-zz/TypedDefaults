Pod::Spec.new do |s|
  s.name = 'TypedDefaults'
  s.version = '1.0.0'
  s.license = 'MIT'
  s.summary = '`TypedDefaults` is a utility library to type-safely use NSUserDefaults'
  s.homepage = 'https://github.com/tasanobu/TypedDefaults'
  s.social_media_url = 'http://twitter.com/tasanobu'
  s.authors = { 'Kazunobu Tasaka' => 'tasanobu@gmail.com' }
  s.source = { :git => 'https://github.com/tasanobu/TypedDefaults.git', :tag => s.version }
  s.ios.deployment_target = '8.0'
  s.source_files = 'TypedDefaults/*.swift'
  s.requires_arc = true
end
