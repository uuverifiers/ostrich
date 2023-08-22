(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^[0-9]{10}GBR[0-9]{7}[U,M,F]{1}[0-9]{9}$
(assert (str.in_re X (re.++ ((_ re.loop 10 10) (re.range "0" "9")) (str.to_re "GBR") ((_ re.loop 7 7) (re.range "0" "9")) ((_ re.loop 1 1) (re.union (str.to_re "U") (str.to_re ",") (str.to_re "M") (str.to_re "F"))) ((_ re.loop 9 9) (re.range "0" "9")) (str.to_re "\u{0a}"))))
; ^([A-z]{2}\d{7})|([A-z]{4}\d{10})$
(assert (not (str.in_re X (re.union (re.++ ((_ re.loop 2 2) (re.range "A" "z")) ((_ re.loop 7 7) (re.range "0" "9"))) (re.++ (str.to_re "\u{0a}") ((_ re.loop 4 4) (re.range "A" "z")) ((_ re.loop 10 10) (re.range "0" "9")))))))
(assert (> (str.len X) 10))
(check-sat)
