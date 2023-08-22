;test regex '1 to 10 of (\d{1,3}[MKB])'
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "\u{27}") (re.++ (str.to_re "1") (re.++ (str.to_re " ") (re.++ (str.to_re "t") (re.++ (str.to_re "o") (re.++ (str.to_re " ") (re.++ (str.to_re "10") (re.++ (str.to_re " ") (re.++ (str.to_re "o") (re.++ (str.to_re "f") (re.++ (str.to_re " ") (re.++ (re.++ ((_ re.loop 1 3) (re.range "0" "9")) (re.union (str.to_re "M") (re.union (str.to_re "K") (str.to_re "B")))) (str.to_re "\u{27}")))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)