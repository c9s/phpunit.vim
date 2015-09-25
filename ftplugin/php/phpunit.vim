highlight default PHPUnitFail guibg=Red ctermbg=Red guifg=White ctermfg=White
highlight default PHPUnitOK guibg=Green ctermbg=Green guifg=Black ctermfg=Black
highlight default PHPUnitAssertFail guifg=LightRed ctermfg=LightRed

let g:PHPUnit = {}
let g:PHPUnit["php"] = '/Users/c9s/.phpbrew/php/php-5.6.10/bin/php'
let g:PHPUnit["phpunit"] = '/Users/c9s/bin/phpunit'
let g:PHPUnit["phpunit_options"] = ['--tap', '--stop-on-failure']

fun! g:PHPUnit.buildBaseCommand()
  let cmd = [g:PHPUnit["php"], g:PHPUnit["phpunit"]]
  let cmd = cmd + g:PHPUnit["phpunit_options"]
  return cmd
endfun

fun! g:PHPUnit.Run(cmd, title)
  redraw
  echohl Title
  echomsg "* Running PHP Unit test(s) [" . a:title . "] *"
  echohl None
  redraw
  echomsg "* Done PHP Unit test(s) [" . a:title . "] *"
  echohl None
  let output = system(join(a:cmd," "))
  silent call g:PHPUnit.OpenBuffer(output)
endfun

fun! g:PHPUnit.OpenBuffer(content)
  " is there phpunit_buffer?
  if exists('g:phpunit_buffer') && bufexists(g:phpunit_buffer)
    let phpunit_win = bufwinnr(g:phpunit_buffer)
    " is buffer visible?
    if phpunit_win > 0
      " switch to visible phpunit buffer
      execute phpunit_win . "wincmd w"
    else
      " split current buffer, with phpunit_buffer
      execute "vertical sb ".g:phpunit_buffer
    endif
    " well, phpunit_buffer is opened, clear content
    setlocal modifiable
    silent %d
  else
    " there is no phpunit_buffer create new one
    rightbelow 50vnew
    let g:phpunit_buffer=bufnr('%')
  endif

  file PHPUnit
  " exec 'file Diff-' . file
  setlocal nobuflisted cursorline nonumber nowrap buftype=nofile filetype=phpunit modifiable bufhidden=hide
  silent put=a:content
  "efm=%E%\\d%\\+)\ %m,%CFailed%m,%Z%f:%l,%-G
  " FIXME: It is better use match(), or :syntax

  call matchadd("PHPUnitFail","^FAILURES.*$")
  call matchadd("PHPUnitOK","^OK .*$")

  call matchadd("PHPUnitFail","^not ok .*$")
  call matchadd("PHPUnitOK","^ok .*$")

  call matchadd("PHPUnitAssertFail","^Failed asserting.*$")
  setlocal nomodifiable
endfun




fun! g:PHPUnit.RunAll()
  let cmd = g:PHPUnit.buildBaseCommand()
  silent call g:PHPUnit.Run(cmd, "RunAll") 
endfun

fun! g:PHPUnit.RunCurrentFile()
  let cmd = g:PHPUnit.buildBaseCommand()
  let cmd = cmd +  [bufname("%")]
  silent call g:PHPUnit.Run(cmd, bufname("%")) 
endfun
fun! g:PHPUnit.RunTestCase(filter)
  let cmd = g:PHPUnit.buildBaseCommand()
  let cmd = cmd + ["--filter", a:filter , bufname("%")]
  silent call g:PHPUnit.Run(cmd, bufname("%") . ":" . a:filter) 
endfun
command! -nargs=0 PHPUnitRunAll :call g:PHPUnit.RunAll()
command! -nargs=0 PHPUnitRunCurrentFile :call g:PHPUnit.RunCurrentFile()
command! -nargs=1 PHPUnitRunFilter :call g:PHPUnit.RunTestCase(<f-args>)
