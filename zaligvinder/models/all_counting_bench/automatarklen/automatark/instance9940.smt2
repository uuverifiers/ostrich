(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^\s*[a-zA-Z0-9&\-\./,\s]+\s*$
(assert (str.in_re X (re.++ (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.+ (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re "&") (str.to_re "-") (str.to_re ".") (str.to_re "/") (str.to_re ",") (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "\u{0a}"))))
; ^(\+?420)? ?[0-9]{3} ?[0-9]{3} ?[0-9]{3}$
(assert (str.in_re X (re.++ (re.opt (re.++ (re.opt (str.to_re "+")) (str.to_re "420"))) (re.opt (str.to_re " ")) ((_ re.loop 3 3) (re.range "0" "9")) (re.opt (str.to_re " ")) ((_ re.loop 3 3) (re.range "0" "9")) (re.opt (str.to_re " ")) ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re "\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
