(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^0(5[012345678]|6[47]){1}(\-)?[^0\D]{1}\d{5}$
(assert (str.in_re X (re.++ (str.to_re "0") ((_ re.loop 1 1) (re.union (re.++ (str.to_re "5") (re.union (str.to_re "0") (str.to_re "1") (str.to_re "2") (str.to_re "3") (str.to_re "4") (str.to_re "5") (str.to_re "6") (str.to_re "7") (str.to_re "8"))) (re.++ (str.to_re "6") (re.union (str.to_re "4") (str.to_re "7"))))) (re.opt (str.to_re "-")) ((_ re.loop 1 1) (re.union (str.to_re "0") (re.comp (re.range "0" "9")))) ((_ re.loop 5 5) (re.range "0" "9")) (str.to_re "\u{0a}"))))
; /\/count\d{2}\.php$/U
(assert (str.in_re X (re.++ (str.to_re "//count") ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re ".php/U\u{0a}"))))
; /filename=[^\n]*\u{2e}gz/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".gz/i\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
