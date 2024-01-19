(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; \b((J(AN|UN|UL))|FEB|MAR|(A(PR|UG))|MAY|SEP|NOV|DEC|OCT)\s*(0?[1-9]|1[0-9]|2[0-9]|3[0-1])\s*(\,)\s*(0[0-9])\b
(assert (not (str.in_re X (re.++ (re.union (re.++ (str.to_re "J") (re.union (str.to_re "AN") (str.to_re "UN") (str.to_re "UL"))) (str.to_re "FEB") (str.to_re "MAR") (re.++ (str.to_re "A") (re.union (str.to_re "PR") (str.to_re "UG"))) (str.to_re "MAY") (str.to_re "SEP") (str.to_re "NOV") (str.to_re "DEC") (str.to_re "OCT")) (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.union (re.++ (re.opt (str.to_re "0")) (re.range "1" "9")) (re.++ (str.to_re "1") (re.range "0" "9")) (re.++ (str.to_re "2") (re.range "0" "9")) (re.++ (str.to_re "3") (re.range "0" "1"))) (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re ",") (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "\u{0a}0") (re.range "0" "9")))))
; ^([A-Z|a-z]{2}-\d{2}-[A-Z|a-z]{2}-\d{1,4})?([A-Z|a-z]{3}-\d{1,4})?$
(assert (not (str.in_re X (re.++ (re.opt (re.++ ((_ re.loop 2 2) (re.union (re.range "A" "Z") (str.to_re "|") (re.range "a" "z"))) (str.to_re "-") ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 2 2) (re.union (re.range "A" "Z") (str.to_re "|") (re.range "a" "z"))) (str.to_re "-") ((_ re.loop 1 4) (re.range "0" "9")))) (re.opt (re.++ ((_ re.loop 3 3) (re.union (re.range "A" "Z") (str.to_re "|") (re.range "a" "z"))) (str.to_re "-") ((_ re.loop 1 4) (re.range "0" "9")))) (str.to_re "\u{0a}")))))
; /^\/\d{9,10}\/1\d{9}\.jar$/U
(assert (str.in_re X (re.++ (str.to_re "//") ((_ re.loop 9 10) (re.range "0" "9")) (str.to_re "/1") ((_ re.loop 9 9) (re.range "0" "9")) (str.to_re ".jar/U\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
