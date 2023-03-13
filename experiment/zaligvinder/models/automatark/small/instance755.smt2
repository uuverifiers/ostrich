(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^[0-9]{6}-[0-9pPtTfF][0-9]{3}$
(assert (str.in_re X (re.++ ((_ re.loop 6 6) (re.range "0" "9")) (str.to_re "-") (re.union (re.range "0" "9") (str.to_re "p") (str.to_re "P") (str.to_re "t") (str.to_re "T") (str.to_re "f") (str.to_re "F")) ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re "\u{0a}"))))
(check-sat)
