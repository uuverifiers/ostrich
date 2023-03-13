(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ((079)|(078)|(077)){1}[0-9]{7}
(assert (not (str.in_re X (re.++ ((_ re.loop 1 1) (re.union (str.to_re "079") (str.to_re "078") (str.to_re "077"))) ((_ re.loop 7 7) (re.range "0" "9")) (str.to_re "\u{0a}")))))
(check-sat)
