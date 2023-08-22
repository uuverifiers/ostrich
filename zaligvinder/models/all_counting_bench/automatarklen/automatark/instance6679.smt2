(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^(\d{2}-\d{2})*$
(assert (str.in_re X (re.++ (re.* (re.++ ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 2 2) (re.range "0" "9")))) (str.to_re "\u{0a}"))))
; (^(352)[8-9](\d{11}$|\d{12}$))|(^(35)[3-8](\d{12}$|\d{13}$))
(assert (not (str.in_re X (re.union (re.++ (str.to_re "352") (re.range "8" "9") (re.union ((_ re.loop 11 11) (re.range "0" "9")) ((_ re.loop 12 12) (re.range "0" "9")))) (re.++ (str.to_re "\u{0a}35") (re.range "3" "8") (re.union ((_ re.loop 12 12) (re.range "0" "9")) ((_ re.loop 13 13) (re.range "0" "9"))))))))
; ^\w*[-]*\w*\\\w*$
(assert (not (str.in_re X (re.++ (re.* (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (re.* (str.to_re "-")) (re.* (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "\u{5c}") (re.* (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
