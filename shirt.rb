#!/usr/bin/env ruby
require 'shellwords'

BUILTINS = { 
  'cd' => lambda { |dir| Dir.chdir(dir) },
  'exit' => lambda { |code = 0| exit(code.to_i) },
  'exec' => lambda { |*command| exec *command }  
}

loop do
  $stdout.print '-> '
  line = $stdin.gets.strip
  command, *arguments = Shellwords.shellsplit(line)

  if BUILTINS[command]
    BUILTINS[command].call(*arguments)
  else
    pid = fork {
      exec line
    }
    Process.wait pid
  end
end