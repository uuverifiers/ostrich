(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^\$( )*\d*(.\d{1,2})?$
(assert (not (str.in_re X (re.++ (str.to_re "$") (re.* (str.to_re " ")) (re.* (re.range "0" "9")) (re.opt (re.++ re.allchar ((_ re.loop 1 2) (re.range "0" "9")))) (str.to_re "\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
