(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; [A-Za-z]{1,2}[\d]{1,2}[A-Za-z]{0,1}
(assert (not (str.in_re X (re.++ ((_ re.loop 1 2) (re.union (re.range "A" "Z") (re.range "a" "z"))) ((_ re.loop 1 2) (re.range "0" "9")) (re.opt (re.union (re.range "A" "Z") (re.range "a" "z"))) (str.to_re "\u{0a}")))))
; /\u{2e}csv([\?\u{5c}\u{2f}]|$)/smiU
(assert (not (str.in_re X (re.++ (str.to_re "/.csv") (re.union (str.to_re "?") (str.to_re "\u{5c}") (str.to_re "/")) (str.to_re "/smiU\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
