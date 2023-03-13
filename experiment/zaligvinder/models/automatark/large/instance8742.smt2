(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; User-Agent\x3A\d+Theef2\sHost\x3A
(assert (not (str.in_re X (re.++ (str.to_re "User-Agent:") (re.+ (re.range "0" "9")) (str.to_re "Theef2") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "Host:\u{0a}")))))
; \u{22}Thewebsearch\.getmirar\.com
(assert (not (str.in_re X (str.to_re "\u{22}Thewebsearch.getmirar.com\u{0a}"))))
; /[a-z]=[a-f0-9]{98}/P
(assert (str.in_re X (re.++ (str.to_re "/") (re.range "a" "z") (str.to_re "=") ((_ re.loop 98 98) (re.union (re.range "a" "f") (re.range "0" "9"))) (str.to_re "/P\u{0a}"))))
(check-sat)
