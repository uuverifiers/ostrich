(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /[^\u{20}-\u{7e}\u{0d}\u{0a}]{4}/P
(assert (not (str.in_re X (re.++ (str.to_re "/") ((_ re.loop 4 4) (re.union (re.range " " "~") (str.to_re "\u{0d}") (str.to_re "\u{0a}"))) (str.to_re "/P\u{0a}")))))
; ^(([0-1][0-9]|2[0-3])[0-5][0-9]\-([0-1][0-9]|2[0-3])[0-5][0-9]|[C|c]losed)$
(assert (not (str.in_re X (re.++ (re.union (re.++ (re.union (re.++ (re.range "0" "1") (re.range "0" "9")) (re.++ (str.to_re "2") (re.range "0" "3"))) (re.range "0" "5") (re.range "0" "9") (str.to_re "-") (re.union (re.++ (re.range "0" "1") (re.range "0" "9")) (re.++ (str.to_re "2") (re.range "0" "3"))) (re.range "0" "5") (re.range "0" "9")) (re.++ (re.union (str.to_re "C") (str.to_re "|") (str.to_re "c")) (str.to_re "losed"))) (str.to_re "\u{0a}")))))
(check-sat)
