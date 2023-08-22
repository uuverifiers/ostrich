(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^((\d{5}-\d{4})|(\d{5})|([A-Z]\d[A-Z]\s\d[A-Z]\d))$
(assert (not (str.in_re X (re.++ (re.union (re.++ ((_ re.loop 5 5) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 4 4) (re.range "0" "9"))) ((_ re.loop 5 5) (re.range "0" "9")) (re.++ (re.range "A" "Z") (re.range "0" "9") (re.range "A" "Z") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (re.range "0" "9") (re.range "A" "Z") (re.range "0" "9"))) (str.to_re "\u{0a}")))))
; ^([a-zA-Z1-9]*)\.(((a|A)(s|S)(p|P)(x|X))|((h|H)(T|t)(m|M)(l|L))|((h|H)(t|T)(M|m))|((a|A)(s|S)(p|P)))
(assert (str.in_re X (re.++ (re.* (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "1" "9"))) (str.to_re ".") (re.union (re.++ (re.union (str.to_re "a") (str.to_re "A")) (re.union (str.to_re "s") (str.to_re "S")) (re.union (str.to_re "p") (str.to_re "P")) (re.union (str.to_re "x") (str.to_re "X"))) (re.++ (re.union (str.to_re "h") (str.to_re "H")) (re.union (str.to_re "T") (str.to_re "t")) (re.union (str.to_re "m") (str.to_re "M")) (re.union (str.to_re "l") (str.to_re "L"))) (re.++ (re.union (str.to_re "h") (str.to_re "H")) (re.union (str.to_re "t") (str.to_re "T")) (re.union (str.to_re "M") (str.to_re "m"))) (re.++ (re.union (str.to_re "a") (str.to_re "A")) (re.union (str.to_re "s") (str.to_re "S")) (re.union (str.to_re "p") (str.to_re "P")))) (str.to_re "\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
