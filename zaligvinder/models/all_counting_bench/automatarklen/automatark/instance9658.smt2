(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^([1-9]|[1-9]\d|1\d{2}|2[0-4]\d|25[0-5])$
(assert (str.in_re X (re.++ (re.union (re.range "1" "9") (re.++ (re.range "1" "9") (re.range "0" "9")) (re.++ (str.to_re "1") ((_ re.loop 2 2) (re.range "0" "9"))) (re.++ (str.to_re "2") (re.range "0" "4") (re.range "0" "9")) (re.++ (str.to_re "25") (re.range "0" "5"))) (str.to_re "\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
