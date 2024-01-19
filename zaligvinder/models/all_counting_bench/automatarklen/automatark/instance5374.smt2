(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /^[a-z\d\u{2b}\u{2f}\u{3d}]{48,256}$/iP
(assert (not (str.in_re X (re.++ (str.to_re "/") ((_ re.loop 48 256) (re.union (re.range "a" "z") (re.range "0" "9") (str.to_re "+") (str.to_re "/") (str.to_re "="))) (str.to_re "/iP\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
