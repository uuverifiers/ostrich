(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /[a-zA-Z]/
(assert (not (str.in_re X (re.++ (str.to_re "/") (re.union (re.range "a" "z") (re.range "A" "Z")) (str.to_re "/\u{0a}")))))
; /\u{2e}s3m([\?\u{5c}\u{2f}]|$)/smiU
(assert (not (str.in_re X (re.++ (str.to_re "/.s3m") (re.union (str.to_re "?") (str.to_re "\u{5c}") (str.to_re "/")) (str.to_re "/smiU\u{0a}")))))
; ^([0-7])*$
(assert (not (str.in_re X (re.++ (re.* (re.range "0" "7")) (str.to_re "\u{0a}")))))
; ^\s*(\d{0,2})(\.?(\d*))?\s*\%?\s*$
(assert (not (str.in_re X (re.++ (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) ((_ re.loop 0 2) (re.range "0" "9")) (re.opt (re.++ (re.opt (str.to_re ".")) (re.* (re.range "0" "9")))) (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.opt (str.to_re "%")) (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "\u{0a}")))))
; ^((0[1-9]|1[0-9]|2[0-4])([0-5]\d){2})$
(assert (not (str.in_re X (re.++ (str.to_re "\u{0a}") (re.union (re.++ (str.to_re "0") (re.range "1" "9")) (re.++ (str.to_re "1") (re.range "0" "9")) (re.++ (str.to_re "2") (re.range "0" "4"))) ((_ re.loop 2 2) (re.++ (re.range "0" "5") (re.range "0" "9")))))))
(assert (> (str.len X) 10))
(check-sat)
