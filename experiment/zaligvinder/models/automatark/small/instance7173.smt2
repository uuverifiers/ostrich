(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^[1-9][0-9]{3}$
(assert (not (str.in_re X (re.++ (re.range "1" "9") ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re "\u{0a}")))))
(check-sat)
