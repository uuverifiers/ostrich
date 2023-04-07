(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^(01)[0-9]{8}
(assert (str.in_re X (re.++ (str.to_re "01") ((_ re.loop 8 8) (re.range "0" "9")) (str.to_re "\u{0a}"))))
(check-sat)