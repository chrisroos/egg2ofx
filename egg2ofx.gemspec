# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{egg2ofx}
  s.version = "0.1.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Chris Roos"]
  s.date = %q{2009-11-13}
  s.default_executable = %q{egg2ofx}
  s.email = %q{chris@seagul.co.uk}
  s.executables = ["egg2ofx"]
  s.extra_rdoc_files = ["README"]
  s.files = ["Rakefile", "README", "bin/egg2ofx", "test/fixtures", "test/fixtures/recent_transactions.html", "test/fixtures/statement.html", "test/integration", "test/integration/recent_transactions_integration_test.rb", "test/integration/statement_integration_test.rb", "test/test_helper.rb", "test/unit", "test/unit/description_test.rb", "test/unit/ofx_test.rb", "test/unit/parser_test.rb", "test/unit/parsers", "test/unit/parsers/recent_transactions_transaction_parser_test.rb", "test/unit/parsers/statement_transaction_parser_test.rb", "lib/egg", "lib/egg/account.rb", "lib/egg/date.rb", "lib/egg/description.rb", "lib/egg/money.rb", "lib/egg/parser.rb", "lib/egg/parsers", "lib/egg/parsers/document_parser.rb", "lib/egg/parsers/recent_transactions_document_parser.rb", "lib/egg/parsers/recent_transactions_transaction_parser.rb", "lib/egg/parsers/statement_document_parser.rb", "lib/egg/parsers/statement_transaction_parser.rb", "lib/egg/parsers/transaction_parser.rb", "lib/egg/statement.rb", "lib/egg/transaction.rb", "lib/egg.rb", "lib/ofx.rb"]
  s.homepage = %q{http://chrisroos.co.uk}
  s.rdoc_options = ["--main", "README"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{egg2ofx}
  s.rubygems_version = %q{1.3.5}
  s.summary = %q{Converts the html statements and recent transactions from the egg site to ofx}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<hpricot>, [">= 0"])
      s.add_development_dependency(%q<mocha>, [">= 0"])
    else
      s.add_dependency(%q<hpricot>, [">= 0"])
      s.add_dependency(%q<mocha>, [">= 0"])
    end
  else
    s.add_dependency(%q<hpricot>, [">= 0"])
    s.add_dependency(%q<mocha>, [">= 0"])
  end
end
