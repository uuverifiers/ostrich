(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^((100)|(\d{0,2}))$
(assert (str.in_re X (re.++ (re.union (str.to_re "100") ((_ re.loop 0 2) (re.range "0" "9"))) (str.to_re "\u{0a}"))))
; ^\$( )*\d*(.\d{1,2})?$
(assert (str.in_re X (re.++ (str.to_re "$") (re.* (str.to_re " ")) (re.* (re.range "0" "9")) (re.opt (re.++ re.allchar ((_ re.loop 1 2) (re.range "0" "9")))) (str.to_re "\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
