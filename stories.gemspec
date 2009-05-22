Gem::Specification.new do |s|
  s.name = 'stories'
  s.version = '0.0.6'
  s.summary = %{Write stories and user acceptance tests using the minimalist testing framework Contest.}
  s.date = %q{2009-04-30}
  s.authors = ["Damian Janowski", "Michel Martens"]
  s.email = "michel@soveran.com"
  s.homepage = "http://github.com/citrusbyte/stories"

  s.specification_version = 2 if s.respond_to? :specification_version=

  s.files = ["lib/stories/runner/pdf.rb", "lib/stories/runner.rb", "lib/stories.rb", "README.markdown", "LICENSE", "Rakefile", "rails/init.rb", "test/all_test.rb", "test/pdf_test.rb"]

  s.require_paths = ['lib']

  s.add_dependency("citrusbyte-contest", ">= 0.0.8")

  s.has_rdoc = false
end
