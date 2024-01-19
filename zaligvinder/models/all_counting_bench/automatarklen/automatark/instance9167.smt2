(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; CZ\d{2}[ ]\d{4}[ ]\d{4}[ ]\d{4}[ ]\d{4}[ ]\d{4}|CZ\d{22}
(assert (not (str.in_re X (re.++ (str.to_re "CZ") (re.union (re.++ ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re " ") ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re " ") ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re " ") ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re " ") ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re " ") ((_ re.loop 4 4) (re.range "0" "9"))) (re.++ ((_ re.loop 22 22) (re.range "0" "9")) (str.to_re "\u{0a}")))))))
(assert (> (str.len X) 10))
(check-sat)
