(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /\u{2e}pui([\?\u{5c}\u{2f}]|$)/smiU
(assert (str.in_re X (re.++ (str.to_re "/.pui") (re.union (str.to_re "?") (str.to_re "\u{5c}") (str.to_re "/")) (str.to_re "/smiU\u{0a}"))))
; ^(([a-zA-Z]{3})?([0-9]{4}))$
(assert (not (str.in_re X (re.++ (str.to_re "\u{0a}") (re.opt ((_ re.loop 3 3) (re.union (re.range "a" "z") (re.range "A" "Z")))) ((_ re.loop 4 4) (re.range "0" "9"))))))
; ^[^ ,0]*$
(assert (not (str.in_re X (re.++ (re.* (re.union (str.to_re " ") (str.to_re ",") (str.to_re "0"))) (str.to_re "\u{0a}")))))
; ^-?\d*(\.\d+)?$
(assert (not (str.in_re X (re.++ (re.opt (str.to_re "-")) (re.* (re.range "0" "9")) (re.opt (re.++ (str.to_re ".") (re.+ (re.range "0" "9")))) (str.to_re "\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
