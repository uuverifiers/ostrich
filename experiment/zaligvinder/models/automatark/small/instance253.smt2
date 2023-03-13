(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^\d{1}(\.\d{3})-\d{3}(\.\d{1})$
(assert (not (str.in_re X (re.++ ((_ re.loop 1 1) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re "\u{0a}.") ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re ".") ((_ re.loop 1 1) (re.range "0" "9"))))))
(check-sat)
