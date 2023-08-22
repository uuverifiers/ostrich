;test regex (regexp_match(foo,'[A-Z][0-9]{10}'))[1]
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "r") (re.++ (str.to_re "e") (re.++ (str.to_re "g") (re.++ (str.to_re "e") (re.++ (str.to_re "x") (re.++ (str.to_re "p") (re.++ (str.to_re "_") (re.++ (str.to_re "m") (re.++ (str.to_re "a") (re.++ (str.to_re "t") (re.++ (str.to_re "c") (re.++ (str.to_re "h") (re.++ (re.++ (str.to_re "f") (re.++ (str.to_re "o") (str.to_re "o"))) (re.++ (str.to_re ",") (re.++ (str.to_re "\u{27}") (re.++ (re.range "A" "Z") (re.++ ((_ re.loop 10 10) (re.range "0" "9")) (str.to_re "\u{27}")))))))))))))))))) (str.to_re "1"))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)