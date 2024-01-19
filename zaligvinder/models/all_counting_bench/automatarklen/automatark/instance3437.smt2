(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; [0-9]{3}P[A-Z][0-9]{7}[0-9X]
(assert (str.in_re X (re.++ ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re "P") (re.range "A" "Z") ((_ re.loop 7 7) (re.range "0" "9")) (re.union (re.range "0" "9") (str.to_re "X")) (str.to_re "\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
