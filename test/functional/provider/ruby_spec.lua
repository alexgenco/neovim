local helpers = require('test.functional.helpers')
local eval, command, feed = helpers.eval, helpers.command, helpers.feed
local eq, clear, insert = helpers.eq, helpers.clear, helpers.insert
local expect, write_file = helpers.expect, helpers.write_file

do
  clear()
  -- load the ruby interpreter and make sure it works at all
end

describe('ruby commands and functions', function()
  before_each(function()
    clear()
    command('ruby require "neovim"')
  end)

  it('feature test', function()
    eq(1, eval('has("ruby")'))
  end)

  -- it('ruby execute', function()
  --   command('ruby nvim.set_var("set_by_ruby", [100, 0])')
  --   eq({100,0}, eval('g:set_by_ruby'))
  -- end)

  -- it('ruby execute with nested commands', function()
  --   -- i might just have to pend this one.
  --   -- command([[ruby nvim.command('ruby nvim.command("ruby nvim.command(\'let set_by_nested_python = 555\')")')]])
  --   -- eq(555, eval('g:set_by_nested_python'))
  -- end)

  -- it('ruby_excute with range', function()
  --   insert([[
  --     line1
  --     line2
  --     line3
  --     line4]])
  --   feed('ggjvj:ruby nvim.set_var("range", nvim.current.buffer.range)<CR>')
  --   eq({'line2','line3'}, eval('g:range'))
  -- end)

  -- it('rubyfile', function()
  --   local fname = 'rbfile.rb'
  --   write_file(fname, 'vim.command("let set_by_rubyfile = 123")')
  --   command('rubyfile rbfile.rb')
  --   eq(123, eval('g:set_by_rubyfile'))
  -- end)

  -- it('rubydo', function()
  --   -- :pydo 42 returns None for all lines,
  --   -- the buffer should not be changed
  --   command('normal :rubydo 42')
  --   eq(0, eval('&mod'))
  --   -- insert some text
  --   insert('abc\ndef\nghi')
  --   expect([[
  --     abc
  --     def
  --     ghi]])
  --   -- go to top and select and replace the first two lines
  --   feed('ggvj:rubydo return str(linenr)<CR>')
  --   expect([[
  --     1
  --     2
  --     ghi]])
  -- end)

  -- it('rubyeval', function()
  --   eq({1, 2, {['key'] = 'val'}}, eval([[rubyeval('[1, 2, {key: "val"}]')]]))
  -- end)
end)
