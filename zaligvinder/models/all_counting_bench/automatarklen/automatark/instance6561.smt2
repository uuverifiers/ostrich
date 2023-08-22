(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /\u{2e}xfdl([\?\u{5c}\u{2f}]|$)/miU
(assert (not (str.in_re X (re.++ (str.to_re "/.xfdl") (re.union (str.to_re "?") (str.to_re "\u{5c}") (str.to_re "/")) (str.to_re "/miU\u{0a}")))))
; ^([a-z]{2,3}(\.[a-zA-Z][a-zA-Z_$0-9]*)*)\.([A-Z][a-zA-Z_$0-9]*)$
(assert (str.in_re X (re.++ (str.to_re ".\u{0a}") ((_ re.loop 2 3) (re.range "a" "z")) (re.* (re.++ (str.to_re ".") (re.union (re.range "a" "z") (re.range "A" "Z")) (re.* (re.union (re.range "a" "z") (re.range "A" "Z") (str.to_re "_") (str.to_re "$") (re.range "0" "9"))))) (re.range "A" "Z") (re.* (re.union (re.range "a" "z") (re.range "A" "Z") (str.to_re "_") (str.to_re "$") (re.range "0" "9"))))))
; ^(((ht|f)tp(s?))\://).*$
(assert (str.in_re X (re.++ (re.* re.allchar) (str.to_re "\u{0a}://") (re.union (str.to_re "ht") (str.to_re "f")) (str.to_re "tp") (re.opt (str.to_re "s")))))
(assert (> (str.len X) 10))
(check-sat)
