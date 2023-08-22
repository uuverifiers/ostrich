(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; SecureNet.*\x2Fsearchfast\x2F
(assert (str.in_re X (re.++ (str.to_re "SecureNet") (re.* re.allchar) (str.to_re "/searchfast/\u{0a}"))))
; ^0$|^0\.{1}(\d{1,2})$|^[1-9]{1}[0-9]*\.?(\d{1,2})$|^[1-9]+[0-9]*$
(assert (str.in_re X (re.union (str.to_re "0") (re.++ (str.to_re "0") ((_ re.loop 1 1) (str.to_re ".")) ((_ re.loop 1 2) (re.range "0" "9"))) (re.++ ((_ re.loop 1 1) (re.range "1" "9")) (re.* (re.range "0" "9")) (re.opt (str.to_re ".")) ((_ re.loop 1 2) (re.range "0" "9"))) (re.++ (re.+ (re.range "1" "9")) (re.* (re.range "0" "9")) (str.to_re "\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
