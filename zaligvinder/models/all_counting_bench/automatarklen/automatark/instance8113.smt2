(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^07[789]-\d{7}$
(assert (not (str.in_re X (re.++ (str.to_re "07") (re.union (str.to_re "7") (str.to_re "8") (str.to_re "9")) (str.to_re "-") ((_ re.loop 7 7) (re.range "0" "9")) (str.to_re "\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
