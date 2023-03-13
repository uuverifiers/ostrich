(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^\d{1,2}\/\d{1,2}\/\d{4}$
(assert (str.in_re X (re.++ ((_ re.loop 1 2) (re.range "0" "9")) (str.to_re "/") ((_ re.loop 1 2) (re.range "0" "9")) (str.to_re "/") ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re "\u{0a}"))))
; ^0(5[012345678]|6[47]){1}(\-)?[^0\D]{1}\d{5}$
(assert (not (str.in_re X (re.++ (str.to_re "0") ((_ re.loop 1 1) (re.union (re.++ (str.to_re "5") (re.union (str.to_re "0") (str.to_re "1") (str.to_re "2") (str.to_re "3") (str.to_re "4") (str.to_re "5") (str.to_re "6") (str.to_re "7") (str.to_re "8"))) (re.++ (str.to_re "6") (re.union (str.to_re "4") (str.to_re "7"))))) (re.opt (str.to_re "-")) ((_ re.loop 1 1) (re.union (str.to_re "0") (re.comp (re.range "0" "9")))) ((_ re.loop 5 5) (re.range "0" "9")) (str.to_re "\u{0a}")))))
; .*-[0-9]{1,10}.*
(assert (str.in_re X (re.++ (re.* re.allchar) (str.to_re "-") ((_ re.loop 1 10) (re.range "0" "9")) (re.* re.allchar) (str.to_re "\u{0a}"))))
(check-sat)
