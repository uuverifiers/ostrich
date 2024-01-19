(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /\/ddd\/[a-z]{2}.gif/iU
(assert (not (str.in_re X (re.++ (str.to_re "//ddd/") ((_ re.loop 2 2) (re.range "a" "z")) re.allchar (str.to_re "gif/iU\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
