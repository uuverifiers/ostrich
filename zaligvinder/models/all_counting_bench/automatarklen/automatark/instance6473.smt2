(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; [1-2][0|9][0-9]{2}[0-1][0-9][0-3][0-9][-][0-9]{4}
(assert (not (str.in_re X (re.++ (re.range "1" "2") (re.union (str.to_re "0") (str.to_re "|") (str.to_re "9")) ((_ re.loop 2 2) (re.range "0" "9")) (re.range "0" "1") (re.range "0" "9") (re.range "0" "3") (re.range "0" "9") (str.to_re "-") ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re "\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
