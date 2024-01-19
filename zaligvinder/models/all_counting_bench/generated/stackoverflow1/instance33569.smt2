;test regex ^\d{1,3}$|^[0-1][0-4]\d{2}$|^1500$
(declare-const X String)
(assert (str.in_re X (re.union (re.union (re.++ (re.++ (str.to_re "") ((_ re.loop 1 3) (re.range "0" "9"))) (str.to_re "")) (re.++ (re.++ (str.to_re "") (re.++ (re.range "0" "1") (re.++ (re.range "0" "4") ((_ re.loop 2 2) (re.range "0" "9"))))) (str.to_re ""))) (re.++ (re.++ (str.to_re "") (str.to_re "1500")) (str.to_re "")))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)