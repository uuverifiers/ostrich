(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^\s*
(assert (not (str.in_re X (re.++ (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "\u{0a}")))))
; ^0(5[012345678]|6[47]){1}(\-)?[^0\D]{1}\d{5}$
(assert (not (str.in_re X (re.++ (str.to_re "0") ((_ re.loop 1 1) (re.union (re.++ (str.to_re "5") (re.union (str.to_re "0") (str.to_re "1") (str.to_re "2") (str.to_re "3") (str.to_re "4") (str.to_re "5") (str.to_re "6") (str.to_re "7") (str.to_re "8"))) (re.++ (str.to_re "6") (re.union (str.to_re "4") (str.to_re "7"))))) (re.opt (str.to_re "-")) ((_ re.loop 1 1) (re.union (str.to_re "0") (re.comp (re.range "0" "9")))) ((_ re.loop 5 5) (re.range "0" "9")) (str.to_re "\u{0a}")))))
; (^\d{5}\x2D\d{3}$)
(assert (str.in_re X (re.++ (str.to_re "\u{0a}") ((_ re.loop 5 5) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 3 3) (re.range "0" "9")))))
; ^(FR)?\s?[A-Z0-9-[IO]]{2}[0-9]{9}$
(assert (str.in_re X (re.++ (re.opt (str.to_re "FR")) (re.opt (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.union (re.range "A" "Z") (re.range "0" "9") (str.to_re "-") (str.to_re "[") (str.to_re "I") (str.to_re "O")) ((_ re.loop 2 2) (str.to_re "]")) ((_ re.loop 9 9) (re.range "0" "9")) (str.to_re "\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
