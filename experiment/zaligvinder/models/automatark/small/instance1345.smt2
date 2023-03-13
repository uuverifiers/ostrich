(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^[AaWaKkNn][a-zA-Z]?[0-9][a-zA-Z]{1,3}$
(assert (str.in_re X (re.++ (re.union (str.to_re "A") (str.to_re "a") (str.to_re "W") (str.to_re "K") (str.to_re "k") (str.to_re "N") (str.to_re "n")) (re.opt (re.union (re.range "a" "z") (re.range "A" "Z"))) (re.range "0" "9") ((_ re.loop 1 3) (re.union (re.range "a" "z") (re.range "A" "Z"))) (str.to_re "\u{0a}"))))
(check-sat)
