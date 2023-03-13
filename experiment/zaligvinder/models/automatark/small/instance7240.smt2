(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^([1-9]|[1-9]\d|[1-2]\d{2}|3[0-6][0-6])$
(assert (str.in_re X (re.++ (re.union (re.range "1" "9") (re.++ (re.range "1" "9") (re.range "0" "9")) (re.++ (re.range "1" "2") ((_ re.loop 2 2) (re.range "0" "9"))) (re.++ (str.to_re "3") (re.range "0" "6") (re.range "0" "6"))) (str.to_re "\u{0a}"))))
(check-sat)
