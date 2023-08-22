;test regex "[0-9]{2}[A-Z][a-z]{6}[3,7]"
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "\u{22}") (re.++ ((_ re.loop 2 2) (re.range "0" "9")) (re.++ (re.range "A" "Z") (re.++ ((_ re.loop 6 6) (re.range "a" "z")) (re.++ (re.union (str.to_re "3") (re.union (str.to_re ",") (str.to_re "7"))) (str.to_re "\u{22}"))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)