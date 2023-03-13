(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /\u{2e}eot([\?\u{5c}\u{2f}]|$)/smiU
(assert (str.in_re X (re.++ (str.to_re "/.eot") (re.union (str.to_re "?") (str.to_re "\u{5c}") (str.to_re "/")) (str.to_re "/smiU\u{0a}"))))
; ^-?(\d+(,\d{3})*(\.\d+)?|\d?(\.\d+))$
(assert (not (str.in_re X (re.++ (re.opt (str.to_re "-")) (re.union (re.++ (re.+ (re.range "0" "9")) (re.* (re.++ (str.to_re ",") ((_ re.loop 3 3) (re.range "0" "9")))) (re.opt (re.++ (str.to_re ".") (re.+ (re.range "0" "9"))))) (re.++ (re.opt (re.range "0" "9")) (str.to_re ".") (re.+ (re.range "0" "9")))) (str.to_re "\u{0a}")))))
(check-sat)
