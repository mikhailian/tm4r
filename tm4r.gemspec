Gem::Specification.new do |s|
   s.name = %q{tm4r}
   s.version = "0.9"
   s.date = %q{2008-07-17}
   s.authors = ["Alexander Mikhailian"]
   s.email = %q{mikhailian@mova.org}
   s.has_rdoc = true
   s.summary = %q{Minimal Topic Maps engine.}
   s.homepage = %q{http://tm4r.mova.org/}
   s.description = %q{TM4R is a Topic Maps engine written in Ruby. Largely inspired by RTM [http://rtm.topicmapslab.de]}
   s.files = Dir.glob('**/*.rb').reject {|e| e =~ /^\.gem(spec)?$/} + %w[LICENSE README]
   s.add_dependency('activerecord', '>= 2.1.0')
   s.add_dependency('activesupport', '>= 2.1.0')
   s.add_dependency('log4r', '>= 1.0.5')
   s.add_dependency('foreign_key_migrations', '>=0.3.0')
   s.requirements << 'sqlite3-ruby >= 1.2.1'
end
