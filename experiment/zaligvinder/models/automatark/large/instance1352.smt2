(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^[0-9]{2,3}-? ?[0-9]{6,7}$
(assert (not (str.in_re X (re.++ ((_ re.loop 2 3) (re.range "0" "9")) (re.opt (str.to_re "-")) (re.opt (str.to_re " ")) ((_ re.loop 6 7) (re.range "0" "9")) (str.to_re "\u{0a}")))))
; IT\d{2}[ ][a-zA-Z]\d{3}[ ]\d{4}[ ]\d{4}[ ]\d{4}[ ]\d{4}[ ]\d{3}|IT\d{2}[a-zA-Z]\d{22}
(assert (str.in_re X (re.++ (str.to_re "IT") (re.union (re.++ ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re " ") (re.union (re.range "a" "z") (re.range "A" "Z")) ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re " ") ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re " ") ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re " ") ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re " ") ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re " ") ((_ re.loop 3 3) (re.range "0" "9"))) (re.++ ((_ re.loop 2 2) (re.range "0" "9")) (re.union (re.range "a" "z") (re.range "A" "Z")) ((_ re.loop 22 22) (re.range "0" "9")) (str.to_re "\u{0a}"))))))
; ^[1-9][0-9][0-9][0-9][0-9][0-9]$
(assert (not (str.in_re X (re.++ (re.range "1" "9") (re.range "0" "9") (re.range "0" "9") (re.range "0" "9") (re.range "0" "9") (re.range "0" "9") (str.to_re "\u{0a}")))))
(check-sat)
