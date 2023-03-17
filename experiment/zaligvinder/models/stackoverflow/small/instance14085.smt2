;test regex "1865259[0-9]{3}|18652[6-9][0-9]{4}|18653[0-6][0-1][0-9]{3}"
(declare-const X String)
(assert (str.in_re X (re.union (re.union (re.++ (str.to_re "\u{22}") (re.++ (str.to_re "1865259") ((_ re.loop 3 3) (re.range "0" "9")))) (re.++ (str.to_re "18652") (re.++ (re.range "6" "9") ((_ re.loop 4 4) (re.range "0" "9"))))) (re.++ (str.to_re "18653") (re.++ (re.range "0" "6") (re.++ (re.range "0" "1") (re.++ ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re "\u{22}"))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)