(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^[2-9][0-8]\d[2-9]\d{6}$
(assert (str.in_re X (re.++ (re.range "2" "9") (re.range "0" "8") (re.range "0" "9") (re.range "2" "9") ((_ re.loop 6 6) (re.range "0" "9")) (str.to_re "\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
