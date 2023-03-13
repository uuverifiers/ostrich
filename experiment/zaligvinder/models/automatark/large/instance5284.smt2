(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; [A-Za-z]{1,2}[\d]{1,2}[A-Za-z]{0,1}\s*[\d]
(assert (not (str.in_re X (re.++ ((_ re.loop 1 2) (re.union (re.range "A" "Z") (re.range "a" "z"))) ((_ re.loop 1 2) (re.range "0" "9")) (re.opt (re.union (re.range "A" "Z") (re.range "a" "z"))) (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.range "0" "9") (str.to_re "\u{0a}")))))
; ^([0-9]*)+(,[0-9]+)+$
(assert (str.in_re X (re.++ (re.+ (re.* (re.range "0" "9"))) (re.+ (re.++ (str.to_re ",") (re.+ (re.range "0" "9")))) (str.to_re "\u{0a}"))))
; ^([a-zA-Z0-9]([a-zA-Z0-9\-]{0,61}[a-zA-Z0-9])?\.)*[a-zA-Z0-9]([a-zA-Z0-9\-]{0,61}[a-zA-Z0-9])?$
(assert (str.in_re X (re.++ (re.* (re.++ (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9")) (re.opt (re.++ ((_ re.loop 0 61) (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re "-"))) (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9")))) (str.to_re "."))) (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9")) (re.opt (re.++ ((_ re.loop 0 61) (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re "-"))) (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9")))) (str.to_re "\u{0a}"))))
; ((PL|SK)-?)?[0-9]{10}
(assert (not (str.in_re X (re.++ (re.opt (re.++ (re.union (str.to_re "PL") (str.to_re "SK")) (re.opt (str.to_re "-")))) ((_ re.loop 10 10) (re.range "0" "9")) (str.to_re "\u{0a}")))))
(check-sat)
