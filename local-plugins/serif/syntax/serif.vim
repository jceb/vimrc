if exists("b:current_syntax")
  finish
endif

let b:current_syntax = "serif"

setlocal iskeyword=@,48-57,95,192-255

syntax cluster SerifExpression contains=SerifString,SerifRawString,SerifKeyword,SerifOperator,SerifNumber,SerifIdentifier

syntax match SerifComment "\v#.*$"
highlight link SerifComment Comment

syntax match SerifDelimiter +\v[][}{)(,;:]+

syntax region SerifString start=;\v"; skip=;\v\\[\\"]; end=;\v"; contains=SerifEscapeSequence,SerifLineContinuation extend
syntax match SerifLineContinuation contained ;\v\\\r?\n *\\;
syntax match SerifEscapeSequence contained ;\v\\[\\"nrt]|\\x\x{1,6};
highlight link SerifString String
highlight link SerifLineContinuation SerifDelimiter
highlight link SerifEscapeSequence Special

syntax region SerifRawString start=;\v\z(`+)"; end=;\v"\z1;
highlight link SerifRawString String

syntax keyword SerifKeyword import export as from function yield return if then else let while for of throw try assert do null false true this
highlight link SerifKeyword Keyword

" Keep the following lines sorted!
syntax match SerifOperator "\V!"
syntax match SerifOperator "\V!="
syntax match SerifOperator "\V$"
syntax match SerifOperator "\V&"
syntax match SerifOperator "\V&&"
syntax match SerifOperator "\V*"
syntax match SerifOperator "\V+"
syntax match SerifOperator "\V++"
syntax match SerifOperator "\V-"
syntax match SerifOperator "\V."
syntax match SerifOperator "\V.&."
syntax match SerifOperator "\V.."
syntax match SerifOperator "\V.0>."
syntax match SerifOperator "\V.<."
syntax match SerifOperator "\V.>."
syntax match SerifOperator "\V.^."
syntax match SerifOperator "\V.|."
syntax match SerifOperator "\V/"
syntax match SerifOperator "\V<"
syntax match SerifOperator "\V<$>"
syntax match SerifOperator "\V<*>"
syntax match SerifOperator "\V</>"
syntax match SerifOperator "\V<<<"
syntax match SerifOperator "\V<="
syntax match SerifOperator "\V<??>"
syntax match SerifOperator "\V<|>"
syntax match SerifOperator "\V="
syntax match SerifOperator "\V=="
syntax match SerifOperator "\V=>"
syntax match SerifOperator "\V>"
syntax match SerifOperator "\V>="
syntax match SerifOperator "\V>>="
syntax match SerifOperator "\V>>>"
syntax match SerifOperator "\V??"
syntax match SerifOperator "\V\\"
syntax match SerifOperator "\V^"
syntax match SerifOperator "\V||"
syntax match SerifOperator "\V~"
syntax keyword SerifOperator eq
syntax keyword SerifOperator gt
syntax keyword SerifOperator gte
syntax keyword SerifOperator in
syntax keyword SerifOperator lt
syntax keyword SerifOperator lte
syntax keyword SerifOperator mod
syntax keyword SerifOperator new
syntax keyword SerifOperator rem
highlight link SerifOperator Operator

syntax match SerifIdentifier "\v[^\u0020\u00A0\u1680\u2000\u2001\u2002\u2003\u2004\u2005\u2006\u2007\u2008\u2009\u200A\u202F\u205F\u3000\u0009\u000B\u000C\uFEFF\u000A\u000D\u2028\u2029\x21\x22\x23\x24\x25\x26\x27\x28\x29\x2A\x2B\x2C\x2D\x2E\x2F\x3A\x3B\x3C\x3D\x3E\x3F\x40\x5B\x5C\x5D\x5E\x60\x7B\x7C\x7D\x7E[:digit:]][^\u0020\u00A0\u1680\u2000\u2001\u2002\u2003\u2004\u2005\u2006\u2007\u2008\u2009\u200A\u202F\u205F\u3000\u0009\u000B\u000C\uFEFF\u000A\u000D\u2028\u2029\x21\x22\x23\x24\x25\x26\x27\x28\x29\x2A\x2B\x2C\x2D\x2E\x2F\x3A\x3B\x3C\x3D\x3E\x3F\x40\x5B\x5C\x5D\x5E\x60\x7B\x7C\x7D\x7E]*"
highlight link SerifIdentifier Identifier

syntax match SerifNumber "\v[+-]?(0|[1-9](_?\d)*)([.]\d(_?\d)*)?([eE][+-]?\d(_?\d)*)?"
syntax match SerifNumber "\v[+-]?(0|[1-9](_?\d)*)n"
syntax match SerifNumber "\v[+-]?0[bB][01](_?[01])*"
syntax match SerifNumber "\v[+-]?0[oO]\o(_?\o)*"
syntax match SerifNumber "\v[+-]?0[xX]\x(_?\x)*"
highlight link SerifNumber Number

syntax match SerifPlaceholder "\v\%([1-9]\d*)?"
highlight link SerifPlaceholder Special
