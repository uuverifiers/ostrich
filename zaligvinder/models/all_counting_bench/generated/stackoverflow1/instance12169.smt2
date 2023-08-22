;test regex 0x[0-9ABCDEF]{3,}|\-[1-9]+
(declare-const X String)
(assert (str.in_re X (re.union (re.++ (str.to_re "0") (re.++ (str.to_re "x") (re.++ (re.* (re.union (re.range "0" "9") (re.union (str.to_re "A") (re.union (str.to_re "B") (re.union (str.to_re "C") (re.union (str.to_re "D") (re.union (str.to_re "E") (str.to_re "F")))))))) ((_ re.loop 3 3) (re.union (re.range "0" "9") (re.union (str.to_re "A") (re.union (str.to_re "B") (re.union (str.to_re "C") (re.union (str.to_re "D") (re.union (str.to_re "E") (str.to_re "F"))))))))))) (re.++ (str.to_re "-") (re.+ (re.range "1" "9"))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)