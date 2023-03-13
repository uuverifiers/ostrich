(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^([-]?[0-9])$|^([-]?[1][0-2])$
(assert (str.in_re X (re.union (re.++ (re.opt (str.to_re "-")) (re.range "0" "9")) (re.++ (str.to_re "\u{0a}") (re.opt (str.to_re "-")) (str.to_re "1") (re.range "0" "2")))))
; &[a-zA-Z]+\d{0,3};
(assert (str.in_re X (re.++ (str.to_re "&") (re.+ (re.union (re.range "a" "z") (re.range "A" "Z"))) ((_ re.loop 0 3) (re.range "0" "9")) (str.to_re ";\u{0a}"))))
; ^(000-)(\\d{5}-){2}\\d{3}$
(assert (str.in_re X (re.++ (str.to_re "000-") ((_ re.loop 2 2) (re.++ (str.to_re "\u{5c}") ((_ re.loop 5 5) (str.to_re "d")) (str.to_re "-"))) (str.to_re "\u{5c}") ((_ re.loop 3 3) (str.to_re "d")) (str.to_re "\u{0a}"))))
(check-sat)
