(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^[a-zA-Z]+(([\'\,\.\-][a-zA-Z])?[a-zA-Z]*)*$
(assert (str.in_re X (re.++ (re.+ (re.union (re.range "a" "z") (re.range "A" "Z"))) (re.* (re.++ (re.opt (re.++ (re.union (str.to_re "'") (str.to_re ",") (str.to_re ".") (str.to_re "-")) (re.union (re.range "a" "z") (re.range "A" "Z")))) (re.* (re.union (re.range "a" "z") (re.range "A" "Z"))))) (str.to_re "\u{0a}"))))
; ^[\\(]{0,1}[0-9]{3}([\\)]{0,1}|-|\s){0,1}[0-9]{3}(-|\s){0,1}[0-9]{4}$
(assert (str.in_re X (re.++ (re.opt (re.union (str.to_re "\u{5c}") (str.to_re "("))) ((_ re.loop 3 3) (re.range "0" "9")) (re.opt (re.union (re.opt (re.union (str.to_re "\u{5c}") (str.to_re ")"))) (str.to_re "-") (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) ((_ re.loop 3 3) (re.range "0" "9")) (re.opt (re.union (str.to_re "-") (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re "\u{0a}"))))
; <img([^>]*[^/])>
(assert (str.in_re X (re.++ (str.to_re "<img>\u{0a}") (re.* (re.comp (str.to_re ">"))) (re.comp (str.to_re "/")))))
(check-sat)
