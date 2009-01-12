Gem::Specification.new do |s|
  s.name = %q{with}
  s.version = "0.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Sammy Larbi"]
  s.date = %q{2009-01-12}
  s.description = %q{I sometimes get a little descriptive with my variable names, so when you're doing a lot of work  specifically with one object, it gets especially ugly and repetetive, making the code harder to  read than it needs to be:  @contract_participants_on_drugs.contract_id = params[:contract_id] @contract_participants_on_drugs.participant_name = params[:participant_name] @contract_participants_on_drugs.drug_conviction = DrugConvictions.find(:wtf => 'this is getting ridiculous') ...  And so on. It gets ridiculous.  Utility Belt implements a with(object) method via a change to Object:  class Object #utility belt implementation def with(object, &block) object.instance_eval &block end end  Unfortunately, that just executes the block in the context of the object, so there isn't any  crossover, nor can you perform assignments with attr_accessors (that I was able to do, anyway).  So, here's With.object() to fill the void.   With.object(@foo) do  a = "wtf" b = "this is not as bad" end  In the above example, @foo.a and @foo.b are the variables getting set.  If you prefer, you can require 'with_on_object' instead and use the notation with(object) do ... end.  The tests in the /test directory offer more examples of what's been implemented and tested so far  (except where noted - namely performing assignment to a variable that was declared outside the  block, and is not on @foo).  Not everything is working yet, but it works for the simplest, most common cases I've run up  against. More complex tests are on the way, along with code to make them pass.  Special thanks to Reg Braithwaite, for help and ideas along the way.}
  s.email = ["sam@codeodor.com"]
  s.extra_rdoc_files = ["History.txt", "Manifest.txt", "README.rdoc"]
  s.files = ["History.txt", "Manifest.txt", "README.rdoc", "Rakefile", "lib/with.rb", "lib/with_on_object.rb", "lib/with_sexp_processor.rb", "test/foo.rb", "test/test_with.rb", "test/test_with_on_object.rb"]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/codeodor/with/tree/master}
  s.rdoc_options = ["--main", "README"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{with}
  s.rubygems_version = %q{1.2.0}
  s.summary = %q{I sometimes get a little descriptive with my variable names, so when you're doing a lot of work  specifically with one object, it gets especially ugly and repetetive, making the code harder to  read than it needs to be:  @contract_participants_on_drugs.contract_id = params[:contract_id] @contract_participants_on_drugs.participant_name = params[:participant_name] @contract_participants_on_drugs.drug_conviction = DrugConvictions.find(:wtf => 'this is getting ridiculous') ..}
  s.test_files = ["test/test_with_on_object.rb", "test/test_with.rb"]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if current_version >= 3 then
      s.add_development_dependency(%q<newgem>, [">= 1.2.3"])
      s.add_development_dependency(%q<hoe>, [">= 1.8.0"])
    else
      s.add_dependency(%q<newgem>, [">= 1.2.3"])
      s.add_dependency(%q<hoe>, [">= 1.8.0"])
    end
  else
    s.add_dependency(%q<newgem>, [">= 1.2.3"])
    s.add_dependency(%q<hoe>, [">= 1.8.0"])
  end
end
