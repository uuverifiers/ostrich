(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /filename=[^\n]*\u{2e}ogg/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".ogg/i\u{0a}")))))
; (([\w-]+://?|www[.])[^\s()<>]+)
(assert (not (str.in_re X (re.++ (str.to_re "\u{0a}") (re.union (re.++ (re.+ (re.union (str.to_re "-") (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re ":/") (re.opt (str.to_re "/"))) (str.to_re "www.")) (re.+ (re.union (str.to_re "(") (str.to_re ")") (str.to_re "<") (str.to_re ">") (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")))))))
; ^((((0[13578])|(1[02]))[\/]?(([0-2][0-9])|(3[01])))|(((0[469])|(11))[\/]?(([0-2][0-9])|(30)))|(02[\/]?[0-2][0-9]))[\/]?\d{4}$
(assert (not (str.in_re X (re.++ (re.union (re.++ (re.union (re.++ (str.to_re "0") (re.union (str.to_re "1") (str.to_re "3") (str.to_re "5") (str.to_re "7") (str.to_re "8"))) (re.++ (str.to_re "1") (re.union (str.to_re "0") (str.to_re "2")))) (re.opt (str.to_re "/")) (re.union (re.++ (re.range "0" "2") (re.range "0" "9")) (re.++ (str.to_re "3") (re.union (str.to_re "0") (str.to_re "1"))))) (re.++ (re.union (re.++ (str.to_re "0") (re.union (str.to_re "4") (str.to_re "6") (str.to_re "9"))) (str.to_re "11")) (re.opt (str.to_re "/")) (re.union (re.++ (re.range "0" "2") (re.range "0" "9")) (str.to_re "30"))) (re.++ (str.to_re "02") (re.opt (str.to_re "/")) (re.range "0" "2") (re.range "0" "9"))) (re.opt (str.to_re "/")) ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re "\u{0a}")))))
; ^-?((([1]?[0-7][0-9]|[1-9]?[0-9])\.{1}\d{1,6}$)|[1]?[1-8][0]\.{1}0{1,6}$)
(assert (not (str.in_re X (re.++ (re.opt (str.to_re "-")) (re.union (re.++ (re.union (re.++ (re.opt (str.to_re "1")) (re.range "0" "7") (re.range "0" "9")) (re.++ (re.opt (re.range "1" "9")) (re.range "0" "9"))) ((_ re.loop 1 1) (str.to_re ".")) ((_ re.loop 1 6) (re.range "0" "9"))) (re.++ (re.opt (str.to_re "1")) (re.range "1" "8") (str.to_re "0") ((_ re.loop 1 1) (str.to_re ".")) ((_ re.loop 1 6) (str.to_re "0")))) (str.to_re "\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
