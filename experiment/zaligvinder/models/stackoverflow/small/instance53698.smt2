;test regex FooBar(,[0-9]{7}[0-9A-F]{8})+
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "F") (re.++ (str.to_re "o") (re.++ (str.to_re "o") (re.++ (str.to_re "B") (re.++ (str.to_re "a") (re.++ (str.to_re "r") (re.+ (re.++ (str.to_re ",") (re.++ ((_ re.loop 7 7) (re.range "0" "9")) ((_ re.loop 8 8) (re.union (re.range "0" "9") (re.range "A" "F"))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)