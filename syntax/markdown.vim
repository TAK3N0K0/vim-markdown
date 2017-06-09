" Vim syntax file
" Language:     Markdown
" Maintainer:   Tim Pope <vimNOSPAM@tpope.org>
" Filenames:    *.markdown
" Last Change:  2013 May 30

if exists("b:current_syntax")
  finish
endif

if !exists('main_syntax')
  let main_syntax = 'markdown'
endif

runtime! syntax/html.vim
unlet! b:current_syntax

if !exists('g:markdown_fenced_languages')
  let g:markdown_fenced_languages = []
endif
for s:type in map(copy(g:markdown_fenced_languages),'matchstr(v:val,"[^=]*$")')
  if s:type =~ '\.'
    let b:{matchstr(s:type,'[^.]*')}_subtype = matchstr(s:type,'\.\zs.*')
  endif
  exe 'syn include @markdownHighlight'.substitute(s:type,'\.','','g').' syntax/'.matchstr(s:type,'[^.]*').'.vim'
  unlet! b:current_syntax
endfor
unlet! s:type

syn sync minlines=10
syn case ignore

syn match markdownLineBreak " \{2,}$"

syn match markdown "^" nextgroup=@markdownBlock
syn cluster markdownBlock contains=markdownParagraph,markdownRule,markdownBlockquote,markdownCodeBlock,@markdownHeading,markdownList
syn cluster markdownInline contains=markdownLineBreak,markdownLinkText,markdownItalic,markdownBold,markdownCode,markdownEscape,@htmlTop,markdownError,markdownHighlighttex,markdownAutomaticLink

syn region markdownParagraph start="^ \{0,3}\%(#.\+\)\@!\S" end="^\s*$\|\%(\n \{0,3}\%(#.\+\|>\s*\)\)\@=" keepend contains=@markdownInline contained

syn match markdownRule " \{0,3}\* *\* *\*[ *]*$" contained
syn match markdownRule " \{0,3}- *- *-[ -]*$" contained

syn region markdownBlockquote matchgroup=markdownBlockquoteDelimiter start=" \{0,3}>\%(\s\|$\)" end="$" contains=@markdownInline contained 

syn region markdownCodeBlock start=" \{4}" end="$" contained

syn cluster markdownHeading contains=markdownH1,markdownH2,markdownH3,markdownH4,markdownH5,markdownH6
syn match markdownH1 "\%(\%(^\s*\n\)\@<=\|\%^\)\s*\S.*\n=\+\s*$" contains=@markdownInline,markdownHeadingRule contained
syn match markdownH2 "\%(\%(^\s*\n\)\@<=\|\%^\)\s*\S.*\n-\+\s*$" contains=@markdownInline,markdownHeadingRule contained
syn match markdownHeadingRule "^[=-]\+\s*$" contained
syn region markdownH1 matchgroup=markdownHeadingDelimiter start="^ \{0,3}##\@!"      end="$" keepend oneline contains=@markdownInline contained
syn region markdownH2 matchgroup=markdownHeadingDelimiter start="^ \{0,3}###\@!"     end="$" keepend oneline contains=@markdownInline contained
syn region markdownH3 matchgroup=markdownHeadingDelimiter start="^ \{0,3}####\@!"    end="$" keepend oneline contains=@markdownInline contained
syn region markdownH4 matchgroup=markdownHeadingDelimiter start="^ \{0,3}#####\@!"   end="$" keepend oneline contains=@markdownInline contained
syn region markdownH5 matchgroup=markdownHeadingDelimiter start="^ \{0,3}######\@!"  end="$" keepend oneline contains=@markdownInline contained
syn region markdownH6 matchgroup=markdownHeadingDelimiter start="^ \{0,3}#######\@!" end="$" keepend oneline contains=@markdownInline contained

syn region markdownList start="\%(\%(^\s*\n\)\@<=\|\%^\) \{0,3}\%([*+-]\|\d\+\.\)\s\+\S" end="^\s*\%(\n \{0,3}\S\)\@=\n" contained keepend contains=markdownListItemBlockL1

syn region markdownListItemBlockL1 start="^ \{0,3}\%([*+-]\|\d\+\.\)\s\+\S" end="\n\%( \{0,3}\%([*+-]\|\d\+\.\)\s\+\S\)\@=\|^\s*\%(\n \{0,3}\S\)\@=\n" contained keepend contains=markdownListItemL1,markdownListMarkerL1,markdownListItemBlockL2
syn match markdownListMarkerL1 "\%(^ \{0,3}\)\@<=\%([*+-]\|\d\+\.\)\%(\s\+\S\)\@=" contained
syn match markdownListItemL1 "\%(^ \{0,3}\%([*+-]\|\d\+\.\)\s\+\)\@<=\S.*\%(\n\%( *\%([*+-]\|\d\+\.\)\s\+\S\)\@!\s*\S.*\)*$" contained keepend contains=@markdownInline

syn region markdownListItemBlockL2 start="^ \{4,7}\%([*+-]\|\d\+\.\)\s\+\S" end="\n\%( \{4,7}\%([*+-]\|\d\+\.\)\s\+\S\)\@=\|^\s*\%(\n \{4,7}\S\)\@=\n" contained keepend contains=markdownListItemL2,markdownListMarkerL2
syn match markdownListMarkerL2 "\%(^ \{4,7}\)\@<=\%([*+-]\|\d\+\.\)\%(\s\+\S\)\@=" contained
syn match markdownListItemL2 "\%(^ \{4,7}\%([*+-]\|\d\+\.\)\s\+\)\@<=\S.*\%(\n\%( *\%([*+-]\|\d\+\.\)\s\+\S\)\@!\s*\S.*\)*$" contained keepend contains=@markdownInline

syn region markdownIdDeclaration matchgroup=markdownLinkDelimiter start="^ \{0,3\}!\=\[" end="\]:" oneline keepend nextgroup=markdownUrl skipwhite
syn match markdownUrl "\S\+" nextgroup=markdownUrlTitle skipwhite contained
syn region markdownUrl matchgroup=markdownUrlDelimiter start="<" end=">" oneline keepend nextgroup=markdownUrlTitle skipwhite contained
syn region markdownUrlTitle matchgroup=markdownUrlTitleDelimiter start=+"+ end=+"+ keepend contained
syn region markdownUrlTitle matchgroup=markdownUrlTitleDelimiter start=+'+ end=+'+ keepend contained
syn region markdownUrlTitle matchgroup=markdownUrlTitleDelimiter start=+(+ end=+)+ keepend contained

syn region markdownLinkText matchgroup=markdownLinkTextDelimiter start="!\=\[\%(\_[^]]*]\%( \=[[(]\)\)\@=" end="\]\%( \=[[(]\)\@=" nextgroup=markdownLink,markdownId skipwhite contains=@markdownInline,markdownLineStart
syn region markdownLink matchgroup=markdownLinkDelimiter start="(" end=")" contains=markdownUrl keepend contained
syn region markdownId matchgroup=markdownIdDelimiter start="\[" end="\]" keepend contained
syn region markdownAutomaticLink matchgroup=markdownUrlDelimiter start="<\%(\w\+:\|[[:alnum:]_+-]\+@\)\@=" end=">" keepend oneline contained

syn region markdownItalic matchgroup=markdownItalicDelimiter start="\S\@<=\*\|\*\S\@=" end="\S\@<=\*\|\*\S\@=" keepend contained contains=markdownLineStart
syn region markdownItalic matchgroup=markdownItalicDelimiter start="\S\@<=_\|_\S\@=" end="\S\@<=_\|_\S\@=" keepend contained contains=markdownLineStart
syn region markdownBold matchgroup=markdownBoldDelimiter start="\S\@<=\*\*\|\*\*\S\@=" end="\S\@<=\*\*\|\*\*\S\@=" keepend contained contains=markdownLineStart,markdownItalic
syn region markdownBold matchgroup=markdownBoldDelimiter start="\S\@<=__\|__\S\@=" end="\S\@<=__\|__\S\@=" keepend contained contains=markdownLineStart,markdownItalic
syn region markdownBoldItalic matchgroup=markdownBoldItalicDelimiter start="\S\@<=\*\*\*\|\*\*\*\S\@=" end="\S\@<=\*\*\*\|\*\*\*\S\@=" keepend contained contains=markdownLineStart
syn region markdownBoldItalic matchgroup=markdownBoldItalicDelimiter start="\S\@<=___\|___\S\@=" end="\S\@<=___\|___\S\@=" keepend contained contains=markdownLineStart

syn region markdownCode matchgroup=markdownCodeDelimiter start="`" end="`" keepend contains=markdownLineStart
syn region markdownCode matchgroup=markdownCodeDelimiter start="`` \=" end=" \=``" keepend contains=markdownLineStart
syn region markdownCode matchgroup=markdownCodeDelimiter start="^\s*```.*$" end="^\s*```\ze\s*$" keepend

syn match markdownFootnote "\[^[^\]]\+\]"
syn match markdownFootnoteDefinition "^\[^[^\]]\+\]:"

if main_syntax ==# 'markdown'
  for s:type in g:markdown_fenced_languages
    exe 'syn region markdownHighlight'.substitute(matchstr(s:type,'[^=]*$'),'\..*','','').' matchgroup=markdownCodeDelimiter start="^\s*```\s*'.matchstr(s:type,'[^=]*').'\>.*$" end="^\s*```\ze\s*$" keepend contains=@markdownHighlight'.substitute(matchstr(s:type,'[^=]*$'),'\.','','g')
  endfor
  unlet! s:type
endif

syn match markdownEscape "\\[][\\`*_{}()#+.!-]"
syn match markdownError "\w\@<=_\w\@="

let g:tex_no_error=1
syn include syntax/tex.vim
syn region markdownHighlighttex matchgroup=markdownCodeDelimiter start="\\\\(\ze[^ \n]" end="[^ \n]\zs\\\\)" keepend contains=@texMathZoneGroup
syn region markdownHighlighttex matchgroup=markdownCodeDelimiter start="\\\\\[" end="\\\\\]" keepend contains=@texMathZoneGroup
syn region markdownHighlighttex matchgroup=markdownCodeDelimiter start="\$\ze[^ \n]" end="[^ \n]\zs\$" keepend contains=@texMathZoneGroup
syn region markdownHighlighttex matchgroup=markdownCodeDelimiter start="\$\$" end="\$\$" keepend contains=@texMathZoneGroup

hi def link markdownH1                    htmlH1
hi def link markdownH2                    htmlH2
hi def link markdownH3                    htmlH3
hi def link markdownH4                    htmlH4
hi def link markdownH5                    htmlH5
hi def link markdownH6                    htmlH6
hi def link markdownHeadingRule           markdownRule
hi def link markdownHeadingDelimiter      Delimiter
hi def link markdownListMarkerL1          htmlTagName
hi def link markdownListMarkerL2          htmlTagName
hi def link markdownBlockquoteDelimiter   Comment
hi     link markdownBlockquote            Normal
hi def link markdownRule                  PreProc

hi def link markdownFootnote              Typedef
hi def link markdownFootnoteDefinition    Typedef

hi def link markdownLinkText              htmlLink
hi def link markdownIdDeclaration         Typedef
hi def link markdownId                    Type
hi def link markdownAutomaticLink         markdownUrl
hi def link markdownUrl                   Float
hi def link markdownUrlTitle              String
hi def link markdownIdDelimiter           markdownLinkDelimiter
hi def link markdownUrlDelimiter          htmlTag
hi def link markdownUrlTitleDelimiter     Delimiter

hi def link markdownItalic                htmlItalic
hi def link markdownItalicDelimiter       markdownItalic
hi def link markdownBold                  htmlBold
hi def link markdownBoldDelimiter         markdownBold
hi def link markdownBoldItalic            htmlBoldItalic
hi def link markdownBoldItalicDelimiter   markdownBoldItalic
hi def link markdownCodeDelimiter         Delimiter

hi def link markdownEscape                Special
hi def link markdownError                 Error

let b:current_syntax = "markdown"
if main_syntax ==# 'markdown'
  unlet main_syntax
endif

" vim:set sw=2:
