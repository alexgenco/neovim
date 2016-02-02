require 'neovim'

$stderr.puts "Started Ruby Script Host"

class Neovim::Current
  attr_accessor :range
end

Neovim.plugin do |plug|
  plug.command(:Test, nargs: 0, sync: true) do
    'msg recieved'
  end

  plug.command(:ruby_test, nargs: 0, sync: true) do
    'msg recieved'
  end

  plug.command(:ruby_execute, nargs: 3, sync: true) do |nvim, script, start, stop|
    $stderr.puts "#{nvim.current} #{nvim.current}"
    nvim.current.buffer.range = Range.new(start, stop - start)
    eval(script)
  end

  plug.command(:ruby_execute_file, nargs: 3, sync: true) do |file, start, stop|
    return 'execute file recieved'
  end

  plug.command(:ruby_do_range, nargs: 2, sync: true) do |start, stop|
    return 'execute do range'
  end
end
