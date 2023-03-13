(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^([1-9]\d{3}|0[1-9]\d{2}|00[1-9]\d{1}|000[1-9]{1})$
(assert (str.in_re X (re.++ (re.union (re.++ (re.range "1" "9") ((_ re.loop 3 3) (re.range "0" "9"))) (re.++ (str.to_re "0") (re.range "1" "9") ((_ re.loop 2 2) (re.range "0" "9"))) (re.++ (str.to_re "00") (re.range "1" "9") ((_ re.loop 1 1) (re.range "0" "9"))) (re.++ (str.to_re "000") ((_ re.loop 1 1) (re.range "1" "9")))) (str.to_re "\u{0a}"))))
(check-sat)
