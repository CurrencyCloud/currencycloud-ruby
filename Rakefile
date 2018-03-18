desc 'Run an IRB session'
task :console do
  exec 'irb -I lib -r irb/completion -r currency_cloud'
end

def play
  sleep 1
  puts '...'
  IRB.conf[:MAIN_CONTEXT].irb
  IRB.conf[:MAIN_CONTEXT].io.prompt = 'HELLO'
end

desc 'Run an IRB session in kiosk mode'
task :kiosk do
  Thread.abort_on_exception = true
  # exec "irb -I lib -r irb/completion -r currency_cloud -r currency_cloud/kiosk"
  require 'irb'
  IRB.setup nil
  IRB.conf[:MAIN_CONTEXT] = IRB::Irb.new.context
  require 'irb/ext/multi-irb'
  Thread.new { play }
  @irb = IRB.irb nil, self
end

desc 'Test and build gem'
task :build do
  sh('rm -f currency_cloud*.gem')
  sh('rspec')
  sh('gem build currency_cloud.gemspec')
end
