(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; aohobygi\u{2f}zwiw\s+\+The\+password\+is\x3A
(assert (not (str.in_re X (re.++ (str.to_re "aohobygi/zwiw") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "+The+password+is:\u{0a}")))))
; ^([A-HJ-TP-Z]{1}\d{4}[A-Z]{3}|[a-z]{1}\d{4}[a-hj-tp-z]{3})$
(assert (str.in_re X (re.++ (re.union (re.++ ((_ re.loop 1 1) (re.union (re.range "A" "H") (re.range "J" "T") (re.range "P" "Z"))) ((_ re.loop 4 4) (re.range "0" "9")) ((_ re.loop 3 3) (re.range "A" "Z"))) (re.++ ((_ re.loop 1 1) (re.range "a" "z")) ((_ re.loop 4 4) (re.range "0" "9")) ((_ re.loop 3 3) (re.union (re.range "a" "h") (re.range "j" "t") (re.range "p" "z"))))) (str.to_re "\u{0a}"))))
; ^([A-Z]{0,3}?[0-9]{9}($[0-9]{0}|[A-Z]{1}))
(assert (str.in_re X (re.++ (str.to_re "\u{0a}") ((_ re.loop 0 3) (re.range "A" "Z")) ((_ re.loop 9 9) (re.range "0" "9")) (re.union ((_ re.loop 0 0) (re.range "0" "9")) ((_ re.loop 1 1) (re.range "A" "Z"))))))
(check-sat)
