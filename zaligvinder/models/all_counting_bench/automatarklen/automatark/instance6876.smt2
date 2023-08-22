(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^(0?[1-9]|1[0-2])\/(0?[1-9]|[1-2][0-9]|3[0-1])\/(0[1-9]|[1-9][0-9]|175[3-9]|17[6-9][0-9]|1[8-9][0-9]{2}|[2-9][0-9]{3})$
(assert (not (str.in_re X (re.++ (re.union (re.++ (re.opt (str.to_re "0")) (re.range "1" "9")) (re.++ (str.to_re "1") (re.range "0" "2"))) (str.to_re "/") (re.union (re.++ (re.opt (str.to_re "0")) (re.range "1" "9")) (re.++ (re.range "1" "2") (re.range "0" "9")) (re.++ (str.to_re "3") (re.range "0" "1"))) (str.to_re "/") (re.union (re.++ (str.to_re "0") (re.range "1" "9")) (re.++ (re.range "1" "9") (re.range "0" "9")) (re.++ (str.to_re "175") (re.range "3" "9")) (re.++ (str.to_re "17") (re.range "6" "9") (re.range "0" "9")) (re.++ (str.to_re "1") (re.range "8" "9") ((_ re.loop 2 2) (re.range "0" "9"))) (re.++ (re.range "2" "9") ((_ re.loop 3 3) (re.range "0" "9")))) (str.to_re "\u{0a}")))))
; ^[a-zA-Z]\:\\.*|^\\\\.*
(assert (not (str.in_re X (re.union (re.++ (re.union (re.range "a" "z") (re.range "A" "Z")) (str.to_re ":\u{5c}") (re.* re.allchar)) (re.++ (str.to_re "\u{5c}\u{5c}") (re.* re.allchar) (str.to_re "\u{0a}"))))))
; <title>(.*?)</title>
(assert (not (str.in_re X (re.++ (str.to_re "<title>") (re.* re.allchar) (str.to_re "</title>\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
