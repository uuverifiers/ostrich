(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; (^\d{1,3}$)|(\d{1,3})\.?(\d{0,0}[0,5])
(assert (str.in_re X (re.union ((_ re.loop 1 3) (re.range "0" "9")) (re.++ ((_ re.loop 1 3) (re.range "0" "9")) (re.opt (str.to_re ".")) (str.to_re "\u{0a}") ((_ re.loop 0 0) (re.range "0" "9")) (re.union (str.to_re "0") (str.to_re ",") (str.to_re "5"))))))
; ^(([1-9][0-9]*)|((([0])|([1-9][0-9]*))\.[0-9]+)|((([1-9][0-9]*)|((([0])|([1-9][0-9]*))\.[0-9]+))\:)*(([1-9][0-9]*)|((([0])|([1-9][0-9]*))\.[0-9]+)))$
(assert (str.in_re X (re.++ (re.union (re.++ (re.range "1" "9") (re.* (re.range "0" "9"))) (re.++ (re.union (str.to_re "0") (re.++ (re.range "1" "9") (re.* (re.range "0" "9")))) (str.to_re ".") (re.+ (re.range "0" "9"))) (re.++ (re.* (re.++ (re.union (re.++ (re.range "1" "9") (re.* (re.range "0" "9"))) (re.++ (re.union (str.to_re "0") (re.++ (re.range "1" "9") (re.* (re.range "0" "9")))) (str.to_re ".") (re.+ (re.range "0" "9")))) (str.to_re ":"))) (re.union (re.++ (re.range "1" "9") (re.* (re.range "0" "9"))) (re.++ (re.union (str.to_re "0") (re.++ (re.range "1" "9") (re.* (re.range "0" "9")))) (str.to_re ".") (re.+ (re.range "0" "9")))))) (str.to_re "\u{0a}"))))
(check-sat)
