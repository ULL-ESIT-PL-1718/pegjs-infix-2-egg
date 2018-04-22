task :default => :evm

desc "Clean grammar"
task :clean do
  sh "pegjs-strip --strip-comment --clean-semantic infix2egg.pegjs"
end

desc "Compile infix2egg.pegjs"
task :compile do
  sh "pegjs infix2egg.pegjs"
end

desc "Run i2e.js examples/minus.inf"
task :run => :compile do
  sh "node i2e.js examples/minus.inf"
end

desc "debug i2e.js examples/minus.inf"
task :deb => :compile do
  sh "node inspect i2e.js examples/minus.inf"
end

desc "run evm examples/minus.inf.evm"
task :evm => :run do
  sh "crguezl-egg/bin/evm.js examples/minus.inf.evm"
end

desc "Run i2e.js examples/paren.inf"
task :run_paren => :compile do
  sh "node i2e.js examples/paren.inf"
end

desc "debug i2e.js examples/paren.inf"
task :deb_paren => :compile do
  sh "node inspect i2e.js examples/paren.inf"
end

desc "run evm examples/paren.inf.evm"
task :evm_paren => :run do
  sh "crguezl-egg/bin/evm.js examples/paren.inf.evm"
end
