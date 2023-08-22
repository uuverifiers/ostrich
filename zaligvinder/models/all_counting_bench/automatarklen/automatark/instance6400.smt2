(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; \binterface\b.*(\bI[_]\w*\b)
(assert (not (str.in_re X (re.++ (str.to_re "interface") (re.* re.allchar) (str.to_re "\u{0a}I_") (re.* (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_")))))))
; ^[0-9]{2}[-][0-9]{2}[-][0-9]{2}$
(assert (str.in_re X (re.++ ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re "\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
