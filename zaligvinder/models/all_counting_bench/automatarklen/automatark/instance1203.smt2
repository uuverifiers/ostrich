(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^(\d{5}-\d{4}|\d{5})$
(assert (str.in_re X (re.++ (re.union (re.++ ((_ re.loop 5 5) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 4 4) (re.range "0" "9"))) ((_ re.loop 5 5) (re.range "0" "9"))) (str.to_re "\u{0a}"))))
; Current[^\n\r]*server[^\n\r]*Host\x3Aocllceclbhs\u{2f}gth
(assert (not (str.in_re X (re.++ (str.to_re "Current") (re.* (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}"))) (str.to_re "server") (re.* (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}"))) (str.to_re "Host:ocllceclbhs/gth\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
