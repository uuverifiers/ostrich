(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ';([dmstrl])([ .,?!\)\\/<])
(assert (str.in_re X (re.++ (str.to_re "';") (re.union (str.to_re "d") (str.to_re "m") (str.to_re "s") (str.to_re "t") (str.to_re "r") (str.to_re "l")) (re.union (str.to_re " ") (str.to_re ".") (str.to_re ",") (str.to_re "?") (str.to_re "!") (str.to_re ")") (str.to_re "\u{5c}") (str.to_re "/") (str.to_re "<")) (str.to_re "\u{0a}"))))
; ^(([0-9]{5})|([0-9]{3}[ ]{0,1}[0-9]{2}))$
(assert (str.in_re X (re.++ (re.union ((_ re.loop 5 5) (re.range "0" "9")) (re.++ ((_ re.loop 3 3) (re.range "0" "9")) (re.opt (str.to_re " ")) ((_ re.loop 2 2) (re.range "0" "9")))) (str.to_re "\u{0a}"))))
; ^(-?)(,?)(\d{1,3}(\.\d{3})*|(\d+))(\,\d{2})?$
(assert (not (str.in_re X (re.++ (re.opt (str.to_re "-")) (re.opt (str.to_re ",")) (re.union (re.++ ((_ re.loop 1 3) (re.range "0" "9")) (re.* (re.++ (str.to_re ".") ((_ re.loop 3 3) (re.range "0" "9"))))) (re.+ (re.range "0" "9"))) (re.opt (re.++ (str.to_re ",") ((_ re.loop 2 2) (re.range "0" "9")))) (str.to_re "\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
