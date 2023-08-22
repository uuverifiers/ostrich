;test regex ^test_Index_\d+-{0,1}\d*_E01\.pdf$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ (str.to_re "t") (re.++ (str.to_re "e") (re.++ (str.to_re "s") (re.++ (str.to_re "t") (re.++ (str.to_re "_") (re.++ (str.to_re "I") (re.++ (str.to_re "n") (re.++ (str.to_re "d") (re.++ (str.to_re "e") (re.++ (str.to_re "x") (re.++ (str.to_re "_") (re.++ (re.+ (re.range "0" "9")) (re.++ ((_ re.loop 0 1) (str.to_re "-")) (re.++ (re.* (re.range "0" "9")) (re.++ (str.to_re "_") (re.++ (str.to_re "E") (re.++ (str.to_re "01") (re.++ (str.to_re ".") (re.++ (str.to_re "p") (re.++ (str.to_re "d") (str.to_re "f")))))))))))))))))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)