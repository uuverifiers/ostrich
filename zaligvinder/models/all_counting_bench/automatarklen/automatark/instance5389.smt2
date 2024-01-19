(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; (^\b\d+-\d+$\b)|(^\b\d+$\b)
(assert (not (str.in_re X (re.union (re.++ (re.+ (re.range "0" "9")) (str.to_re "-") (re.+ (re.range "0" "9"))) (re.++ (re.+ (re.range "0" "9")) (str.to_re "\u{0a}"))))))
; ^([6011]{4})([0-9]{12})$
(assert (not (str.in_re X (re.++ ((_ re.loop 4 4) (re.union (str.to_re "6") (str.to_re "0") (str.to_re "1"))) ((_ re.loop 12 12) (re.range "0" "9")) (str.to_re "\u{0a}")))))
; ^[2-5](2|4|6|8|0)(A(A)?|B|C|D(D(D)?)?|E|F|G|H)$
(assert (not (str.in_re X (re.++ (re.range "2" "5") (re.union (str.to_re "2") (str.to_re "4") (str.to_re "6") (str.to_re "8") (str.to_re "0")) (re.union (re.++ (str.to_re "A") (re.opt (str.to_re "A"))) (str.to_re "B") (str.to_re "C") (re.++ (str.to_re "D") (re.opt (re.++ (str.to_re "D") (re.opt (str.to_re "D"))))) (str.to_re "E") (str.to_re "F") (str.to_re "G") (str.to_re "H")) (str.to_re "\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
