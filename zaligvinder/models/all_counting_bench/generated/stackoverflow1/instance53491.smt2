;test regex (((\d+)(,?\s?|.)(\d{1,2}))\s?(PLN|EUR|USD|CHF|GBP))
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (re.+ (re.range "0" "9")) (re.++ (re.union (re.++ (re.opt (str.to_re ",")) (re.opt (re.union (str.to_re " ") (re.union (str.to_re "\u{0b}") (re.union (str.to_re "\u{0a}") (re.union (str.to_re "\u{0d}") (re.union (str.to_re "\u{09}") (str.to_re "\u{0c}")))))))) (re.diff re.allchar (str.to_re "\n"))) ((_ re.loop 1 2) (re.range "0" "9")))) (re.++ (re.opt (re.union (str.to_re " ") (re.union (str.to_re "\u{0b}") (re.union (str.to_re "\u{0a}") (re.union (str.to_re "\u{0d}") (re.union (str.to_re "\u{09}") (str.to_re "\u{0c}"))))))) (re.union (re.union (re.union (re.union (re.++ (str.to_re "P") (re.++ (str.to_re "L") (str.to_re "N"))) (re.++ (str.to_re "E") (re.++ (str.to_re "U") (str.to_re "R")))) (re.++ (str.to_re "U") (re.++ (str.to_re "S") (str.to_re "D")))) (re.++ (str.to_re "C") (re.++ (str.to_re "H") (str.to_re "F")))) (re.++ (str.to_re "G") (re.++ (str.to_re "B") (str.to_re "P"))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)