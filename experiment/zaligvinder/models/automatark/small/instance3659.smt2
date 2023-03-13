(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /^\/[a-z]{2,20}\.php\?[a-z]{2,10}\u{3d}[a-zA-Z0-9\u{2f}\u{2b}]+\u{3d}$/I
(assert (not (str.in_re X (re.++ (str.to_re "//") ((_ re.loop 2 20) (re.range "a" "z")) (str.to_re ".php?") ((_ re.loop 2 10) (re.range "a" "z")) (str.to_re "=") (re.+ (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re "/") (str.to_re "+"))) (str.to_re "=/I\u{0a}")))))
(check-sat)
