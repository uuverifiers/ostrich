(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /\/install\.asp\?mac=[A-F\d]{12}\u{26}mode/Ui
(assert (str.in_re X (re.++ (str.to_re "//install.asp?mac=") ((_ re.loop 12 12) (re.union (re.range "A" "F") (re.range "0" "9"))) (str.to_re "&mode/Ui\u{0a}"))))
; (\+91(-)?|91(-)?|0(-)?)?(9)[0-9]{9}
(assert (not (str.in_re X (re.++ (re.opt (re.union (re.++ (str.to_re "+91") (re.opt (str.to_re "-"))) (re.++ (str.to_re "91") (re.opt (str.to_re "-"))) (re.++ (str.to_re "0") (re.opt (str.to_re "-"))))) (str.to_re "9") ((_ re.loop 9 9) (re.range "0" "9")) (str.to_re "\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
