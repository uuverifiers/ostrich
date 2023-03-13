(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^[0-9]{8}R[A-HJ-NP-TV-Z]$
(assert (not (str.in_re X (re.++ ((_ re.loop 8 8) (re.range "0" "9")) (str.to_re "R") (re.union (re.range "A" "H") (re.range "J" "N") (re.range "P" "T") (re.range "V" "Z")) (str.to_re "\u{0a}")))))
(check-sat)
