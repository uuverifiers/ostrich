(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^[A-Z9]{5}[0-9]([05][1-9]|[16][0-2])(0[1-9]|[12][0-9]|3[01])[0-9][A-Z9][0-9][A-Z0-9]([0-9]{2}?)$
(assert (str.in_re X (re.++ ((_ re.loop 5 5) (re.union (re.range "A" "Z") (str.to_re "9"))) (re.range "0" "9") (re.union (re.++ (re.union (str.to_re "0") (str.to_re "5")) (re.range "1" "9")) (re.++ (re.union (str.to_re "1") (str.to_re "6")) (re.range "0" "2"))) (re.union (re.++ (str.to_re "0") (re.range "1" "9")) (re.++ (re.union (str.to_re "1") (str.to_re "2")) (re.range "0" "9")) (re.++ (str.to_re "3") (re.union (str.to_re "0") (str.to_re "1")))) (re.range "0" "9") (re.union (re.range "A" "Z") (str.to_re "9")) (re.range "0" "9") (re.union (re.range "A" "Z") (re.range "0" "9")) ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re "\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
