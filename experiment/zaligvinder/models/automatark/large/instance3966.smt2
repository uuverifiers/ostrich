(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /\u{2f}[a-z-_]{90,}\u{2e}(html|php)$/U
(assert (str.in_re X (re.++ (str.to_re "//.") (re.union (str.to_re "html") (str.to_re "php")) (str.to_re "/U\u{0a}") ((_ re.loop 90 90) (re.union (re.range "a" "z") (str.to_re "-") (str.to_re "_"))) (re.* (re.union (re.range "a" "z") (str.to_re "-") (str.to_re "_"))))))
(check-sat)
