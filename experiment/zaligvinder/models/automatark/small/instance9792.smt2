(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^((\d[-. ]?)?((\(\d{3}\))|\d{3}))?[-. ]?\d{3}[-. ]?\d{4}$
(assert (str.in_re X (re.++ (re.opt (re.++ (re.opt (re.++ (re.range "0" "9") (re.opt (re.union (str.to_re "-") (str.to_re ".") (str.to_re " "))))) (re.union (re.++ (str.to_re "(") ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re ")")) ((_ re.loop 3 3) (re.range "0" "9"))))) (re.opt (re.union (str.to_re "-") (str.to_re ".") (str.to_re " "))) ((_ re.loop 3 3) (re.range "0" "9")) (re.opt (re.union (str.to_re "-") (str.to_re ".") (str.to_re " "))) ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re "\u{0a}"))))
; ^[1-9]{1,2}(.5)?$
(assert (not (str.in_re X (re.++ ((_ re.loop 1 2) (re.range "1" "9")) (re.opt (re.++ re.allchar (str.to_re "5"))) (str.to_re "\u{0a}")))))
(check-sat)
