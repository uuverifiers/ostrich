(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^((\$?\-?)|(\-?\$?))([0-9]{1,3},([0-9]{3},)*[0-9]{3}|[0-9]+)?(\.[0-9]*)?$
(assert (str.in_re X (re.++ (re.union (re.++ (re.opt (str.to_re "$")) (re.opt (str.to_re "-"))) (re.++ (re.opt (str.to_re "-")) (re.opt (str.to_re "$")))) (re.opt (re.union (re.++ ((_ re.loop 1 3) (re.range "0" "9")) (str.to_re ",") (re.* (re.++ ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re ","))) ((_ re.loop 3 3) (re.range "0" "9"))) (re.+ (re.range "0" "9")))) (re.opt (re.++ (str.to_re ".") (re.* (re.range "0" "9")))) (str.to_re "\u{0a}"))))
; /\u{2e}png([\?\u{5c}\u{2f}]|$)/smiU
(assert (not (str.in_re X (re.++ (str.to_re "/.png") (re.union (str.to_re "?") (str.to_re "\u{5c}") (str.to_re "/")) (str.to_re "/smiU\u{0a}")))))
; ^([0-9]|[1-9][0-9]|[1-9][0-9][0-9])$
(assert (str.in_re X (re.++ (re.union (re.range "0" "9") (re.++ (re.range "1" "9") (re.range "0" "9")) (re.++ (re.range "1" "9") (re.range "0" "9") (re.range "0" "9"))) (str.to_re "\u{0a}"))))
(check-sat)
