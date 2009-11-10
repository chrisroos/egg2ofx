require 'rake/testtask'

desc "Run the tests for egg2ofx."
Rake::TestTask.new(:default) do |t|
  t.libs       << 'test'
  t.test_files = FileList['test/**/*_test.rb']
  t.verbose    = true
end