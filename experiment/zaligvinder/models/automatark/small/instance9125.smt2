(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /\/\[fx]\.jar$/U
(assert (not (str.in_re X (str.to_re "//[fx].jar/U\u{0a}"))))
; [cC]{1}[0-9]{0,7}
(assert (str.in_re X (re.++ ((_ re.loop 1 1) (re.union (str.to_re "c") (str.to_re "C"))) ((_ re.loop 0 7) (re.range "0" "9")) (str.to_re "\u{0a}"))))
; ^([0]\d|[1][0-2])\/([0-2]\d|[3][0-1])\/([2][01]|[1][6-9])\d{2}(\s([0]\d|[1][0-2])(\:[0-5]\d){1,2})*\s*([aApP][mM]{0,2})?$
(assert (str.in_re X (re.++ (re.union (re.++ (str.to_re "0") (re.range "0" "9")) (re.++ (str.to_re "1") (re.range "0" "2"))) (str.to_re "/") (re.union (re.++ (re.range "0" "2") (re.range "0" "9")) (re.++ (str.to_re "3") (re.range "0" "1"))) (str.to_re "/") (re.union (re.++ (str.to_re "2") (re.union (str.to_re "0") (str.to_re "1"))) (re.++ (str.to_re "1") (re.range "6" "9"))) ((_ re.loop 2 2) (re.range "0" "9")) (re.* (re.++ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (re.union (re.++ (str.to_re "0") (re.range "0" "9")) (re.++ (str.to_re "1") (re.range "0" "2"))) ((_ re.loop 1 2) (re.++ (str.to_re ":") (re.range "0" "5") (re.range "0" "9"))))) (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.opt (re.++ (re.union (str.to_re "a") (str.to_re "A") (str.to_re "p") (str.to_re "P")) ((_ re.loop 0 2) (re.union (str.to_re "m") (str.to_re "M"))))) (str.to_re "\u{0a}"))))
; ^0(5[012345678]|6[47]){1}(\-)?[^0\D]{1}\d{5}$
(assert (not (str.in_re X (re.++ (str.to_re "0") ((_ re.loop 1 1) (re.union (re.++ (str.to_re "5") (re.union (str.to_re "0") (str.to_re "1") (str.to_re "2") (str.to_re "3") (str.to_re "4") (str.to_re "5") (str.to_re "6") (str.to_re "7") (str.to_re "8"))) (re.++ (str.to_re "6") (re.union (str.to_re "4") (str.to_re "7"))))) (re.opt (str.to_re "-")) ((_ re.loop 1 1) (re.union (str.to_re "0") (re.comp (re.range "0" "9")))) ((_ re.loop 5 5) (re.range "0" "9")) (str.to_re "\u{0a}")))))
; /User-Agent\u{3a}\u{20}Agent\d{5,9}/Hi
(assert (str.in_re X (re.++ (str.to_re "/User-Agent: Agent") ((_ re.loop 5 9) (re.range "0" "9")) (str.to_re "/Hi\u{0a}"))))
(check-sat)
