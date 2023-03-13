(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; (\+91(-)?|91(-)?|0(-)?)?(9)[0-9]{9}
(assert (str.in_re X (re.++ (re.opt (re.union (re.++ (str.to_re "+91") (re.opt (str.to_re "-"))) (re.++ (str.to_re "91") (re.opt (str.to_re "-"))) (re.++ (str.to_re "0") (re.opt (str.to_re "-"))))) (str.to_re "9") ((_ re.loop 9 9) (re.range "0" "9")) (str.to_re "\u{0a}"))))
; ^[a-zA-Z]{1}[0-9]{1}[a-zA-Z]{1}(\-| |){1}[0-9]{1}[a-zA-Z]{1}[0-9]{1}$
(assert (not (str.in_re X (re.++ ((_ re.loop 1 1) (re.union (re.range "a" "z") (re.range "A" "Z"))) ((_ re.loop 1 1) (re.range "0" "9")) ((_ re.loop 1 1) (re.union (re.range "a" "z") (re.range "A" "Z"))) ((_ re.loop 1 1) (re.union (str.to_re "-") (str.to_re " "))) ((_ re.loop 1 1) (re.range "0" "9")) ((_ re.loop 1 1) (re.union (re.range "a" "z") (re.range "A" "Z"))) ((_ re.loop 1 1) (re.range "0" "9")) (str.to_re "\u{0a}")))))
(check-sat)
