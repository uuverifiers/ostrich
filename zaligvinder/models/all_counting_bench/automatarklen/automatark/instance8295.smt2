(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /\x3F[0-9a-z]{32}D/U
(assert (str.in_re X (re.++ (str.to_re "/?") ((_ re.loop 32 32) (re.union (re.range "0" "9") (re.range "a" "z"))) (str.to_re "D/U\u{0a}"))))
; ^(1?(-?\d{3})-?)?(\d{3})(-?\d{4})$
(assert (str.in_re X (re.++ (re.opt (re.++ (re.opt (str.to_re "1")) (re.opt (str.to_re "-")) (re.opt (str.to_re "-")) ((_ re.loop 3 3) (re.range "0" "9")))) ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re "\u{0a}") (re.opt (str.to_re "-")) ((_ re.loop 4 4) (re.range "0" "9")))))
; Host\x3A\dKeylogger.*Onetrustyfiles\x2Ecom
(assert (not (str.in_re X (re.++ (str.to_re "Host:") (re.range "0" "9") (str.to_re "Keylogger") (re.* re.allchar) (str.to_re "Onetrustyfiles.com\u{0a}")))))
; [a-zA-Z0-9]*
(assert (not (str.in_re X (re.++ (re.* (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9"))) (str.to_re "\u{0a}")))))
; ^((\+)?[1-9]{1,2})?([-\s\.])?((\(\d{1,4}\))|\d{1,4})(([-\s\.])?[0-9]{1,12}){1,2}$
(assert (not (str.in_re X (re.++ (re.opt (re.++ (re.opt (str.to_re "+")) ((_ re.loop 1 2) (re.range "1" "9")))) (re.opt (re.union (str.to_re "-") (str.to_re ".") (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.union (re.++ (str.to_re "(") ((_ re.loop 1 4) (re.range "0" "9")) (str.to_re ")")) ((_ re.loop 1 4) (re.range "0" "9"))) ((_ re.loop 1 2) (re.++ (re.opt (re.union (str.to_re "-") (str.to_re ".") (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) ((_ re.loop 1 12) (re.range "0" "9")))) (str.to_re "\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
