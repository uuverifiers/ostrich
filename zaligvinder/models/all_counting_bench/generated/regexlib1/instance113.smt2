;test regex ((\d{0}[0-9]|\d{0}[1]\d{0}[0-2])(\:)\d{0}[0-5]\d{0}[0-9](\:)\d{0}[0-5]\d{0}[0-9]\s(AM|PM))
(declare-const X String)
(assert (str.in_re X (re.++ (re.union (re.++ ((_ re.loop 0 0) (re.range "0" "9")) (re.range "0" "9")) (re.++ ((_ re.loop 0 0) (re.range "0" "9")) (re.++ (str.to_re "1") (re.++ ((_ re.loop 0 0) (re.range "0" "9")) (re.range "0" "2"))))) (re.++ (str.to_re ":") (re.++ ((_ re.loop 0 0) (re.range "0" "9")) (re.++ (re.range "0" "5") (re.++ ((_ re.loop 0 0) (re.range "0" "9")) (re.++ (re.range "0" "9") (re.++ (str.to_re ":") (re.++ ((_ re.loop 0 0) (re.range "0" "9")) (re.++ (re.range "0" "5") (re.++ ((_ re.loop 0 0) (re.range "0" "9")) (re.++ (re.range "0" "9") (re.++ (re.union (str.to_re " ") (re.union (str.to_re "\u{0b}") (re.union (str.to_re "\u{0a}") (re.union (str.to_re "\u{0d}") (re.union (str.to_re "\u{09}") (str.to_re "\u{0c}")))))) (re.union (re.++ (str.to_re "A") (str.to_re "M")) (re.++ (str.to_re "P") (str.to_re "M")))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)