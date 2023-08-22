(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /\u{2e}cnt([\?\u{5c}\u{2f}]|$)/smiU
(assert (str.in_re X (re.++ (str.to_re "/.cnt") (re.union (str.to_re "?") (str.to_re "\u{5c}") (str.to_re "/")) (str.to_re "/smiU\u{0a}"))))
; ^([1-9]{1}(([0-9])?){2})+(,[0-9]{1}[0-9]{2})*$
(assert (str.in_re X (re.++ (re.+ (re.++ ((_ re.loop 1 1) (re.range "1" "9")) ((_ re.loop 2 2) (re.opt (re.range "0" "9"))))) (re.* (re.++ (str.to_re ",") ((_ re.loop 1 1) (re.range "0" "9")) ((_ re.loop 2 2) (re.range "0" "9")))) (str.to_re "\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
