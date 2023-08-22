(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^\d{3}-\d{7}[0-6]{1}$
(assert (not (str.in_re X (re.++ ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 7 7) (re.range "0" "9")) ((_ re.loop 1 1) (re.range "0" "6")) (str.to_re "\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
