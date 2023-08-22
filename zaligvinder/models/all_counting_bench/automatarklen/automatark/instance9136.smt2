(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^([0-1]?[0-9]{1}/[0-3]?[0-9]{1}/20[0-9]{2})$
(assert (str.in_re X (re.++ (str.to_re "\u{0a}") (re.opt (re.range "0" "1")) ((_ re.loop 1 1) (re.range "0" "9")) (str.to_re "/") (re.opt (re.range "0" "3")) ((_ re.loop 1 1) (re.range "0" "9")) (str.to_re "/20") ((_ re.loop 2 2) (re.range "0" "9")))))
; ^[a-zA-Z0-9_\s-]+$
(assert (not (str.in_re X (re.++ (re.+ (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re "_") (str.to_re "-") (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
