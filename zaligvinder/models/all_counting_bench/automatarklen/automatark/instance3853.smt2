(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^[a-zA-z0-9]+[@]{1}[a-zA-Z]+[.]{1}[a-zA-Z]+$
(assert (not (str.in_re X (re.++ (re.+ (re.union (re.range "a" "z") (re.range "A" "z") (re.range "0" "9"))) ((_ re.loop 1 1) (str.to_re "@")) (re.+ (re.union (re.range "a" "z") (re.range "A" "Z"))) ((_ re.loop 1 1) (str.to_re ".")) (re.+ (re.union (re.range "a" "z") (re.range "A" "Z"))) (str.to_re "\u{0a}")))))
; ((0|1[0-9]{0,2}|2[0-9]?|2[0-4][0-9]|25[0-5]|[3-9][0-9]?)\.){3}(0|1[0-9]{0,2}|2[0-9]?|2[0-4][0-9]|25[0-5]|[3-9][0-9]?)
(assert (str.in_re X (re.++ ((_ re.loop 3 3) (re.++ (re.union (str.to_re "0") (re.++ (str.to_re "1") ((_ re.loop 0 2) (re.range "0" "9"))) (re.++ (str.to_re "2") (re.opt (re.range "0" "9"))) (re.++ (str.to_re "2") (re.range "0" "4") (re.range "0" "9")) (re.++ (str.to_re "25") (re.range "0" "5")) (re.++ (re.range "3" "9") (re.opt (re.range "0" "9")))) (str.to_re "."))) (re.union (str.to_re "0") (re.++ (str.to_re "1") ((_ re.loop 0 2) (re.range "0" "9"))) (re.++ (str.to_re "2") (re.opt (re.range "0" "9"))) (re.++ (str.to_re "2") (re.range "0" "4") (re.range "0" "9")) (re.++ (str.to_re "25") (re.range "0" "5")) (re.++ (re.range "3" "9") (re.opt (re.range "0" "9")))) (str.to_re "\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
