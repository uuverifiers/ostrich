(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^([9]{1})([234789]{1})([0-9]{8})$
(assert (str.in_re X (re.++ ((_ re.loop 1 1) (str.to_re "9")) ((_ re.loop 1 1) (re.union (str.to_re "2") (str.to_re "3") (str.to_re "4") (str.to_re "7") (str.to_re "8") (str.to_re "9"))) ((_ re.loop 8 8) (re.range "0" "9")) (str.to_re "\u{0a}"))))
; ^(0|([1-9]\d{0,3}|[1-5]\d{4}|[6][0-5][0-5]([0-2]\d|[3][0-5])))$
(assert (not (str.in_re X (re.++ (re.union (str.to_re "0") (re.++ (re.range "1" "9") ((_ re.loop 0 3) (re.range "0" "9"))) (re.++ (re.range "1" "5") ((_ re.loop 4 4) (re.range "0" "9"))) (re.++ (str.to_re "6") (re.range "0" "5") (re.range "0" "5") (re.union (re.++ (re.range "0" "2") (re.range "0" "9")) (re.++ (str.to_re "3") (re.range "0" "5"))))) (str.to_re "\u{0a}")))))
(check-sat)
