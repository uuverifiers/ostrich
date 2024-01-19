(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^[D-d][K-k]-[1-9]{1}[0-9]{3}$
(assert (str.in_re X (re.++ (re.range "D" "d") (re.range "K" "k") (str.to_re "-") ((_ re.loop 1 1) (re.range "1" "9")) ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re "\u{0a}"))))
; \b(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?).(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?).(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?).(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\b
(assert (str.in_re X (re.++ (re.union (re.++ (str.to_re "25") (re.range "0" "5")) (re.++ (str.to_re "2") (re.range "0" "4") (re.range "0" "9")) (re.++ (re.opt (re.union (str.to_re "0") (str.to_re "1"))) (re.range "0" "9") (re.opt (re.range "0" "9")))) re.allchar (re.union (re.++ (str.to_re "25") (re.range "0" "5")) (re.++ (str.to_re "2") (re.range "0" "4") (re.range "0" "9")) (re.++ (re.opt (re.union (str.to_re "0") (str.to_re "1"))) (re.range "0" "9") (re.opt (re.range "0" "9")))) re.allchar (re.union (re.++ (str.to_re "25") (re.range "0" "5")) (re.++ (str.to_re "2") (re.range "0" "4") (re.range "0" "9")) (re.++ (re.opt (re.union (str.to_re "0") (str.to_re "1"))) (re.range "0" "9") (re.opt (re.range "0" "9")))) re.allchar (re.union (re.++ (str.to_re "25") (re.range "0" "5")) (re.++ (str.to_re "2") (re.range "0" "4") (re.range "0" "9")) (re.++ (re.opt (re.union (str.to_re "0") (str.to_re "1"))) (re.range "0" "9") (re.opt (re.range "0" "9")))) (str.to_re "\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
