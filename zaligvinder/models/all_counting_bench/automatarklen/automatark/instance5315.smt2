(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^([0-9a-fA-F]){8}$
(assert (str.in_re X (re.++ ((_ re.loop 8 8) (re.union (re.range "0" "9") (re.range "a" "f") (re.range "A" "F"))) (str.to_re "\u{0a}"))))
; /\/fnts\.html$/U
(assert (not (str.in_re X (str.to_re "//fnts.html/U\u{0a}"))))
; /\u{2e}fli([\?\u{5c}\u{2f}]|$)/smiU
(assert (not (str.in_re X (re.++ (str.to_re "/.fli") (re.union (str.to_re "?") (str.to_re "\u{5c}") (str.to_re "/")) (str.to_re "/smiU\u{0a}")))))
; ^(a-z|A-Z|0-9)*[^#$%^&*()']*$
(assert (not (str.in_re X (re.++ (re.* (re.union (str.to_re "a-z") (str.to_re "A-Z") (str.to_re "0-9"))) (re.* (re.union (str.to_re "#") (str.to_re "$") (str.to_re "%") (str.to_re "^") (str.to_re "&") (str.to_re "*") (str.to_re "(") (str.to_re ")") (str.to_re "'"))) (str.to_re "\u{0a}")))))
; (DK-?)?([0-9]{2}\ ?){3}[0-9]{2}
(assert (not (str.in_re X (re.++ (re.opt (re.++ (str.to_re "DK") (re.opt (str.to_re "-")))) ((_ re.loop 3 3) (re.++ ((_ re.loop 2 2) (re.range "0" "9")) (re.opt (str.to_re " ")))) ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re "\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
