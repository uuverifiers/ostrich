(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; trustyfiles\x2Ecom\d+lnzzlnbk\u{2f}pkrm\.fin\s+
(assert (str.in_re X (re.++ (str.to_re "trustyfiles.com") (re.+ (re.range "0" "9")) (str.to_re "lnzzlnbk/pkrm.fin") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "\u{0a}"))))
; ^(((0|((\+)?91(\-)?))|((\((\+)?91\)(\-)?)))?[7-9]\d{9})?$
(assert (str.in_re X (re.++ (re.opt (re.++ (re.opt (re.union (re.++ (str.to_re "(") (re.opt (str.to_re "+")) (str.to_re "91)") (re.opt (str.to_re "-"))) (str.to_re "0") (re.++ (re.opt (str.to_re "+")) (str.to_re "91") (re.opt (str.to_re "-"))))) (re.range "7" "9") ((_ re.loop 9 9) (re.range "0" "9")))) (str.to_re "\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
