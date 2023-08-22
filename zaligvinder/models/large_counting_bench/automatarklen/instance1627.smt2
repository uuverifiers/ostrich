(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /^\u{2f}[a-z\u{2d}\u{5f}]{90,97}\.php$/U
(assert (not (str.in_re X (re.++ (str.to_re "//") ((_ re.loop 90 97) (re.union (re.range "a" "z") (str.to_re "-") (str.to_re "_"))) (str.to_re ".php/U\u{0a}")))))
(assert (< 200 (str.len X)))
(check-sat)
