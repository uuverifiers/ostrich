(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; \u{22}Thewebsearch\.getmirar\.com
(assert (str.in_re X (str.to_re "\u{22}Thewebsearch.getmirar.com\u{0a}")))
; /^\/\d{9,10}\/1\d{9}\.jar$/U
(assert (str.in_re X (re.++ (str.to_re "//") ((_ re.loop 9 10) (re.range "0" "9")) (str.to_re "/1") ((_ re.loop 9 9) (re.range "0" "9")) (str.to_re ".jar/U\u{0a}"))))
(check-sat)
