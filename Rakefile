task :default => :run

desc "Clean grammar"
task :clean do
  sh "pegjs-strip --strip-comment --clean-semantic infix2egg.pegjs"
end

desc "Run i2e.js"
task :run => :compile do
  sh "node i2e.js"
end

desc "Run and use the parser generated from infix2egg.pegjs"
task :compile do
  sh "pegjs infix2egg.pegjs"
end
