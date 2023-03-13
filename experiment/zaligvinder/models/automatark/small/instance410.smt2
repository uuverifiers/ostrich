(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^0[234679]{1}[\s]{0,1}[\-]{0,1}[\s]{0,1}[1-9]{1}[0-9]{6}$
(assert (str.in_re X (re.++ (str.to_re "0") ((_ re.loop 1 1) (re.union (str.to_re "2") (str.to_re "3") (str.to_re "4") (str.to_re "6") (str.to_re "7") (str.to_re "9"))) (re.opt (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.opt (str.to_re "-")) (re.opt (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) ((_ re.loop 1 1) (re.range "1" "9")) ((_ re.loop 6 6) (re.range "0" "9")) (str.to_re "\u{0a}"))))
; \b([2-9][p-z][a-h][2-9]{1,2}[a-z]+[p-z][2-9][p-z][2-9][p-z]|[a-z][a-z]+\d{2}[a-z]|[2-9][p-z]{2}[a-h][2-9]{1,2}[a-z]+[p-z][2-9]{3}[p-z]|\d{12}|[2-9][p-z][a-h][2-9][a-z0-9]+[p-z][2-9]{3}[p-z])\b
(assert (not (str.in_re X (re.++ (re.union (re.++ (re.range "2" "9") (re.range "p" "z") (re.range "a" "h") ((_ re.loop 1 2) (re.range "2" "9")) (re.+ (re.range "a" "z")) (re.range "p" "z") (re.range "2" "9") (re.range "p" "z") (re.range "2" "9") (re.range "p" "z")) (re.++ (re.range "a" "z") (re.+ (re.range "a" "z")) ((_ re.loop 2 2) (re.range "0" "9")) (re.range "a" "z")) (re.++ (re.range "2" "9") ((_ re.loop 2 2) (re.range "p" "z")) (re.range "a" "h") ((_ re.loop 1 2) (re.range "2" "9")) (re.+ (re.range "a" "z")) (re.range "p" "z") ((_ re.loop 3 3) (re.range "2" "9")) (re.range "p" "z")) ((_ re.loop 12 12) (re.range "0" "9")) (re.++ (re.range "2" "9") (re.range "p" "z") (re.range "a" "h") (re.range "2" "9") (re.+ (re.union (re.range "a" "z") (re.range "0" "9"))) (re.range "p" "z") ((_ re.loop 3 3) (re.range "2" "9")) (re.range "p" "z"))) (str.to_re "\u{0a}")))))
; ^\d+(\.\d+)?$
(assert (not (str.in_re X (re.++ (re.+ (re.range "0" "9")) (re.opt (re.++ (str.to_re ".") (re.+ (re.range "0" "9")))) (str.to_re "\u{0a}")))))
(check-sat)
