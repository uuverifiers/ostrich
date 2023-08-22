(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; (^\([0]\d{2}\))(\d{6,7}$)
(assert (not (str.in_re X (re.++ ((_ re.loop 6 7) (re.range "0" "9")) (str.to_re "\u{0a}(0") ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re ")")))))
; ^(\d{3}-\d{3}-\d{4})*$
(assert (not (str.in_re X (re.++ (re.* (re.++ ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 4 4) (re.range "0" "9")))) (str.to_re "\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
