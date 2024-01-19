(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; [0-9.\-/+() ]{4,}
(assert (not (str.in_re X (re.++ (str.to_re "\u{0a}") ((_ re.loop 4 4) (re.union (re.range "0" "9") (str.to_re ".") (str.to_re "-") (str.to_re "/") (str.to_re "+") (str.to_re "(") (str.to_re ")") (str.to_re " "))) (re.* (re.union (re.range "0" "9") (str.to_re ".") (str.to_re "-") (str.to_re "/") (str.to_re "+") (str.to_re "(") (str.to_re ")") (str.to_re " ")))))))
; ^[S-s]( |-)?[1-9]{1}[0-9]{2}( |-)?[0-9]{2}$
(assert (not (str.in_re X (re.++ (re.range "S" "s") (re.opt (re.union (str.to_re " ") (str.to_re "-"))) ((_ re.loop 1 1) (re.range "1" "9")) ((_ re.loop 2 2) (re.range "0" "9")) (re.opt (re.union (str.to_re " ") (str.to_re "-"))) ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re "\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
