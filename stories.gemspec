Gem::Specification.new do |s|
  s.name        = "stories"
  s.version     = "0.1.1"
  s.summary     = "Write Stories and User Acceptance Tests using the minimalist testing framework Contest."
  s.description = "Write Stories and User Acceptance Tests using Contest, the tiny add on to Test::Unit that provides nested contexts and declarative tests."
  s.authors     = ["Damian Janowski", "Michel Martens"]
  s.email       = ["djanowski@dimaion.com", "michel@soveran.com"]
  s.homepage    = "http://github.com/citrusbyte/stories"

  s.files = ["lib/tasks/stories.rake", "lib/stories/runner/pdf.rb", "lib/stories/runner.rb", "lib/stories.rb", "README.markdown", "LICENSE", "Rakefile", "rails/init.rb", "test/all_test.rb", "test/pdf_test.rb"]

  s.rubyforge_project = "stories"

  s.add_dependency("contest", "~> 0.1")
end
