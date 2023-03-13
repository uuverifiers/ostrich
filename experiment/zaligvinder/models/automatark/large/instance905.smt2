(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^((0[1-9]|1[0-9]|2[0-4])([0-5]\d){2})$
(assert (str.in_re X (re.++ (str.to_re "\u{0a}") (re.union (re.++ (str.to_re "0") (re.range "1" "9")) (re.++ (str.to_re "1") (re.range "0" "9")) (re.++ (str.to_re "2") (re.range "0" "4"))) ((_ re.loop 2 2) (re.++ (re.range "0" "5") (re.range "0" "9"))))))
; /\u{28}\u{3f}\u{3d}[^)]{300}/
(assert (not (str.in_re X (re.++ (str.to_re "/(?=") ((_ re.loop 300 300) (re.comp (str.to_re ")"))) (str.to_re "/\u{0a}")))))
(check-sat)
