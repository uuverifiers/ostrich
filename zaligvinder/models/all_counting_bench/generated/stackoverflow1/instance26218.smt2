;test regex ([0-9]{8})_([0-9A-Ba-c]+)_BLAH
(declare-const X String)
(assert (str.in_re X (re.++ ((_ re.loop 8 8) (re.range "0" "9")) (re.++ (str.to_re "_") (re.++ (re.+ (re.union (re.range "0" "9") (re.union (re.range "A" "B") (re.range "a" "c")))) (re.++ (str.to_re "_") (re.++ (str.to_re "B") (re.++ (str.to_re "L") (re.++ (str.to_re "A") (str.to_re "H"))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)