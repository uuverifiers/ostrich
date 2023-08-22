(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^([0-9]|[1-9]\d|[1-7]\d{2}|800)$
(assert (str.in_re X (re.++ (re.union (re.range "0" "9") (re.++ (re.range "1" "9") (re.range "0" "9")) (re.++ (re.range "1" "7") ((_ re.loop 2 2) (re.range "0" "9"))) (str.to_re "800")) (str.to_re "\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
