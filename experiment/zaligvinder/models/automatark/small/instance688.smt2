(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; bind\w+Owner\x3A\dBetaWordixqshv\u{2f}qzccs
(assert (str.in_re X (re.++ (str.to_re "bind") (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "Owner:") (re.range "0" "9") (str.to_re "BetaWordixqshv/qzccs\u{0a}"))))
; (\+91(-)?|91(-)?|0(-)?)?(9)[0-9]{9}
(assert (str.in_re X (re.++ (re.opt (re.union (re.++ (str.to_re "+91") (re.opt (str.to_re "-"))) (re.++ (str.to_re "91") (re.opt (str.to_re "-"))) (re.++ (str.to_re "0") (re.opt (str.to_re "-"))))) (str.to_re "9") ((_ re.loop 9 9) (re.range "0" "9")) (str.to_re "\u{0a}"))))
(check-sat)
