(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /^("(\\["\\]|[^"])*"|[^\n])*$/gm
(assert (str.in_re X (re.++ (str.to_re "/") (re.* (re.union (re.++ (str.to_re "\u{22}") (re.* (re.union (re.++ (str.to_re "\u{5c}") (re.union (str.to_re "\u{22}") (str.to_re "\u{5c}"))) (re.comp (str.to_re "\u{22}")))) (str.to_re "\u{22}")) (re.comp (str.to_re "\u{0a}")))) (str.to_re "/gm\u{0a}"))))
; ^([1-9]{0,1})([0-9]{1})((\.[0-9]{0,1})([0-9]{1})|(\,[0-9]{0,1})([0-9]{1}))?$
(assert (str.in_re X (re.++ (re.opt (re.range "1" "9")) ((_ re.loop 1 1) (re.range "0" "9")) (re.opt (re.union (re.++ ((_ re.loop 1 1) (re.range "0" "9")) (str.to_re ".") (re.opt (re.range "0" "9"))) (re.++ ((_ re.loop 1 1) (re.range "0" "9")) (str.to_re ",") (re.opt (re.range "0" "9"))))) (str.to_re "\u{0a}"))))
; ^(([$])?((([0-9]{1,3},)+[0-9]{3})|[0-9]+)(\.[0-9]{2})?)$
(assert (str.in_re X (re.++ (str.to_re "\u{0a}") (re.opt (str.to_re "$")) (re.union (re.++ (re.+ (re.++ ((_ re.loop 1 3) (re.range "0" "9")) (str.to_re ","))) ((_ re.loop 3 3) (re.range "0" "9"))) (re.+ (re.range "0" "9"))) (re.opt (re.++ (str.to_re ".") ((_ re.loop 2 2) (re.range "0" "9")))))))
(assert (> (str.len X) 10))
(check-sat)
