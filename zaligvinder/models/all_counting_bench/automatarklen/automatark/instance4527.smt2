(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^\.([rR]([aA][rR]|\d{2})|(\d{3})?)$
(assert (not (str.in_re X (re.++ (str.to_re ".") (re.union (re.++ (re.union (str.to_re "r") (str.to_re "R")) (re.union (re.++ (re.union (str.to_re "a") (str.to_re "A")) (re.union (str.to_re "r") (str.to_re "R"))) ((_ re.loop 2 2) (re.range "0" "9")))) (re.opt ((_ re.loop 3 3) (re.range "0" "9")))) (str.to_re "\u{0a}")))))
; /^\d+O\d+\.jsp\?[a-z0-9\u{3d}\u{2b}\u{2f}]{20}/iR
(assert (not (str.in_re X (re.++ (str.to_re "/") (re.+ (re.range "0" "9")) (str.to_re "O") (re.+ (re.range "0" "9")) (str.to_re ".jsp?") ((_ re.loop 20 20) (re.union (re.range "a" "z") (re.range "0" "9") (str.to_re "=") (str.to_re "+") (str.to_re "/"))) (str.to_re "/iR\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
