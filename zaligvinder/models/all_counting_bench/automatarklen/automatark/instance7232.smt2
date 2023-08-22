(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^(((\.\.){1}/)*|(/){1})?(([a-zA-Z0-9]*)/)*([a-zA-Z0-9]*)+([.jpg]|[.gif])+$
(assert (not (str.in_re X (re.++ (re.opt (re.union (re.* (re.++ ((_ re.loop 1 1) (str.to_re "..")) (str.to_re "/"))) ((_ re.loop 1 1) (str.to_re "/")))) (re.* (re.++ (re.* (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9"))) (str.to_re "/"))) (re.+ (re.* (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9")))) (re.+ (re.union (str.to_re ".") (str.to_re "j") (str.to_re "p") (str.to_re "g") (str.to_re "i") (str.to_re "f"))) (str.to_re "\u{0a}")))))
; /\u{2e}jp2([\?\u{5c}\u{2f}]|$)/smiU
(assert (str.in_re X (re.++ (str.to_re "/.jp2") (re.union (str.to_re "?") (str.to_re "\u{5c}") (str.to_re "/")) (str.to_re "/smiU\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
