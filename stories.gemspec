Gem::Specification.new do |s|
  s.name     = "stories"
  s.version  = "0.0.9"
  s.summary  = "Write stories and user acceptance tests using the minimalist testing framework Contest."
  s.authors  = ["Damian Janowski", "Michel Martens"]
  s.email    = ["djanowski@dimaion.com", "michel@soveran.com"]
  s.homepage = "http://github.com/citrusbyte/stories"

  s.files = ["lib/tasks/stories.rake", "lib/stories/runner/pdf.rb", "lib/stories/runner.rb", "lib/stories.rb", "README.markdown", "LICENSE", "Rakefile", "rails/init.rb", "test/all_test.rb", "test/pdf_test.rb"]

  s.add_dependency("contest", "~> 0.1")
end
