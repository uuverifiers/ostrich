(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^(GIR|[A-Z]\d[A-Z\d]??|[A-Z]{2}\d[A-Z\d]??)[ ]??(\d[A-Z]{2})$
(assert (not (str.in_re X (re.++ (re.union (str.to_re "GIR") (re.++ (re.range "A" "Z") (re.range "0" "9") (re.opt (re.union (re.range "A" "Z") (re.range "0" "9")))) (re.++ ((_ re.loop 2 2) (re.range "A" "Z")) (re.range "0" "9") (re.opt (re.union (re.range "A" "Z") (re.range "0" "9"))))) (re.opt (str.to_re " ")) (str.to_re "\u{0a}") (re.range "0" "9") ((_ re.loop 2 2) (re.range "A" "Z"))))))
; /^(Frame)?\.jsf/R
(assert (str.in_re X (re.++ (str.to_re "/") (re.opt (str.to_re "Frame")) (str.to_re ".jsf/R\u{0a}"))))
; ^[{|\(]?[0-9a-fA-F]{8}[-]?([0-9a-fA-F]{4}[-]?){3}[0-9a-fA-F]{12}[\)|}]?$
(assert (not (str.in_re X (re.++ (re.opt (re.union (str.to_re "{") (str.to_re "|") (str.to_re "("))) ((_ re.loop 8 8) (re.union (re.range "0" "9") (re.range "a" "f") (re.range "A" "F"))) (re.opt (str.to_re "-")) ((_ re.loop 3 3) (re.++ ((_ re.loop 4 4) (re.union (re.range "0" "9") (re.range "a" "f") (re.range "A" "F"))) (re.opt (str.to_re "-")))) ((_ re.loop 12 12) (re.union (re.range "0" "9") (re.range "a" "f") (re.range "A" "F"))) (re.opt (re.union (str.to_re ")") (str.to_re "|") (str.to_re "}"))) (str.to_re "\u{0a}")))))
; /^[a-z]{5}\d=_\d_/C
(assert (not (str.in_re X (re.++ (str.to_re "/") ((_ re.loop 5 5) (re.range "a" "z")) (re.range "0" "9") (str.to_re "=_") (re.range "0" "9") (str.to_re "_/C\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
