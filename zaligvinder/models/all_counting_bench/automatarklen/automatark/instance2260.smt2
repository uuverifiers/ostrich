(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^((8|\+7)[\- ]?)?(\(?\d{3}\)?[\- ]?)?[\d\- ]{7,10}$
(assert (str.in_re X (re.++ (re.opt (re.++ (re.union (str.to_re "8") (str.to_re "+7")) (re.opt (re.union (str.to_re "-") (str.to_re " "))))) (re.opt (re.++ (re.opt (str.to_re "(")) ((_ re.loop 3 3) (re.range "0" "9")) (re.opt (str.to_re ")")) (re.opt (re.union (str.to_re "-") (str.to_re " "))))) ((_ re.loop 7 10) (re.union (re.range "0" "9") (str.to_re "-") (str.to_re " "))) (str.to_re "\u{0a}"))))
; ^-?((([1]?[0-7][0-9]|[1-9]?[0-9])\.{1}\d{1,6}$)|[1]?[1-8][0]\.{1}0{1,6}$)
(assert (str.in_re X (re.++ (re.opt (str.to_re "-")) (re.union (re.++ (re.union (re.++ (re.opt (str.to_re "1")) (re.range "0" "7") (re.range "0" "9")) (re.++ (re.opt (re.range "1" "9")) (re.range "0" "9"))) ((_ re.loop 1 1) (str.to_re ".")) ((_ re.loop 1 6) (re.range "0" "9"))) (re.++ (re.opt (str.to_re "1")) (re.range "1" "8") (str.to_re "0") ((_ re.loop 1 1) (str.to_re ".")) ((_ re.loop 1 6) (str.to_re "0")))) (str.to_re "\u{0a}"))))
; ^[a-zA-Z0-9_\s-]+$
(assert (str.in_re X (re.++ (re.+ (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re "_") (str.to_re "-") (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
