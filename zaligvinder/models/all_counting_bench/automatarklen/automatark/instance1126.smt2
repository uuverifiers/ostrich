(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; (^\-|\+)?([1-9]{1}[0-9]{0,2}(\,\d{3})*|[1-9]{1}\d{0,})$|^0?$
(assert (str.in_re X (re.union (re.++ (re.opt (re.union (str.to_re "-") (str.to_re "+"))) (re.union (re.++ ((_ re.loop 1 1) (re.range "1" "9")) ((_ re.loop 0 2) (re.range "0" "9")) (re.* (re.++ (str.to_re ",") ((_ re.loop 3 3) (re.range "0" "9"))))) (re.++ ((_ re.loop 1 1) (re.range "1" "9")) (re.* (re.range "0" "9"))))) (re.++ (re.opt (str.to_re "0")) (str.to_re "\u{0a}")))))
; /\u{2e}url([\?\u{5c}\u{2f}]|$)/smiU
(assert (not (str.in_re X (re.++ (str.to_re "/.url") (re.union (str.to_re "?") (str.to_re "\u{5c}") (str.to_re "/")) (str.to_re "/smiU\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
