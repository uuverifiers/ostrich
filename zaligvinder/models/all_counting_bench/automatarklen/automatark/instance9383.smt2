(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^[1-9]\d?-\d{7}$
(assert (not (str.in_re X (re.++ (re.range "1" "9") (re.opt (re.range "0" "9")) (str.to_re "-") ((_ re.loop 7 7) (re.range "0" "9")) (str.to_re "\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
