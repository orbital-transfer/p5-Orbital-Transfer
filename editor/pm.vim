augroup PmAu
	au!
	au BufReadCmd   pm://*  call PmRead(expand("<amatch>"))
	au FileReadCmd  pm://*  call PmRead(expand("<amatch>"))
	au BufWriteCmd  pm://*  call PmWrite(expand("<amatch>"))
	au FileWriteCmd pm://*  call PmWrite(expand("<amatch>"))
	au BufReadPost   pm://*  call PmBufReadPost()
augroup END

let g:pm_bin = '~/sw_projects/SeeLucid/p5-Project-Manager/p5-Project-Manager/bin/pm'
function! PmRead(uri)
	exe "sil! r!".g:pm_bin." text --uri ".a:uri." --read"
	if v:shell_error != 0
		redraw!
		echohl Error | echo "***error*** (PmRead) sorry, unable to fetch pm" | echohl None
	else
		" cleanup
		keepj sil! 0d
		setl nomod
		setf txt
	endif
endfunction

function! PmWrite(uri)
	exe "sil! w !".g:pm_bin." text --uri ".a:uri." --write"
	if v:shell_error != 0
		redraw!
		echohl Error | echo "***error*** (PmWrite) sorry, unable to update pm" | echohl None
	else
		let saved = winsaveview()
		let b:save_cursor = getcurpos()
		let b:tempview = tempname()
		let b:vopsave = &vop
		set vop=folds
		exe 'mkview! ' . b:tempview
		exe "sil! !perl -i -E 'while(<>){ print if /so_save/; $v = 1 if $v == 0 && /setlocal/; $v = 2 if $v == 1 && $_ \\!~ /setlocal/; print if $v == 2 }' " . b:tempview
		sil! %g/^/d
		call PmRead(a:uri)
		exe 'so ' . b:tempview
		let &vop = b:vopsave
		call setpos('.', b:save_cursor)
		call winrestview(saved)
		setlocal nomod
		"exe "sil! doau BufReadPost ".fnameescape(a:uri)
	endif
endfunction

command! Pm exe "new `" . g:pm_bin . " text --auto-uri`"
command! PmCal call PmCal()

function! PmCal()
	let b:tempview = tempname()
	let b:name = system(g:pm_bin . " text --auto-uri")
	exe "sil! !".g:pm_bin." text --remind > " . b:tempview
	exe "sil! !screen -t 'wyrd-". b:name . "' wyrd " . b:tempview
	redraw!
endfunction
