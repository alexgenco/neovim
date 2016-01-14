" The Ruby provider uses a Ruby host to emulate an environment for running
" ruby-vim plugins. See ":help nvim-provider" for more information.
"
" Associating the plugin with the Ruby host is the first step because plugins
" will be passed as command-line arguments

if exists('g:loaded_ruby_provider')
  finish
endif
let g:loaded_ruby_provider = 1

function! s:RequireLegacyRubyHost(host_name)
  try
    let l:host = rpcstart(s:remote_host_path, [s:plugin_path])
    if rpcrequest(l:host, 'poll') == 'ok'
      return l:host
    endif
  catch
    echomsg v:exception
  endtry
  throw 'Failed to load Ruby host. You can try to see what happened '.
    \ 'by starting Neovim with the environment variable '.
    \ '$NVIM_RUBY_LOG_FILE set to a file and opening '.
    \ 'the generated log file. Also, the host stderr will be available '.
    \ 'in Neovim log, so it may contain useful information. '.
    \ 'See also ~/.nvimlog.'
endfunction

try
  let s:remote_host_path = systemlist('which neovim-ruby-host')[0]
  let s:plugin_path = expand('<sfile>:p:h') . '/script_host.rb'
catch
  echomsg "Couldn't find neovim-ruby-host - did you install the gem?"
endtry

let s:err = ''
let s:host = 0

" The Ruby provider plugin will run in a separate instance of the ruby
" host.
call remote#host#Register('ruby', '*.rb', function('s:RequireLegacyRubyHost'))
call remote#host#RegisterClone('legacy-ruby-provider', 'ruby')
call remote#host#RegisterPlugin('legacy-ruby-provider', s:plugin_path, [])

function! provider#ruby#Call(method, args)
  if s:err != ''
    echomsg s:err
    return
  endif

  if !s:host
    let s:rpcrequest = function('rpcrequest')

    " Ensure that we can load the Ruby host before bootstrapping
    try
      let s:host = remote#host#Require('legacy-ruby-provider')
    catch
      let s:err = v:exception
      echohl WarningMsg
      echomsg v:exception
      echohl None
      return
    endtry
  endif
  return call(s:rpcrequest, insert(insert(a:args, 'ruby_'.a:method), s:host))
endfunction
