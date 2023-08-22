;test regex ^\({0,1}((0|\+61)(2|4|3|7|8)){0,1}\){0,1}(\ |-){0,1}[0-9]{2}(\ |-){0,1}[0-9]{2}(\ |-){0,1}[0-9]{1}(\ |-){0,1}[0-9]{3}$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ ((_ re.loop 0 1) (str.to_re "(")) (re.++ ((_ re.loop 0 1) (re.++ (re.union (str.to_re "0") (re.++ (str.to_re "+") (str.to_re "61"))) (re.union (re.union (re.union (re.union (str.to_re "2") (str.to_re "4")) (str.to_re "3")) (str.to_re "7")) (str.to_re "8")))) (re.++ ((_ re.loop 0 1) (str.to_re ")")) (re.++ ((_ re.loop 0 1) (re.union (str.to_re " ") (str.to_re "-"))) (re.++ ((_ re.loop 2 2) (re.range "0" "9")) (re.++ ((_ re.loop 0 1) (re.union (str.to_re " ") (str.to_re "-"))) (re.++ ((_ re.loop 2 2) (re.range "0" "9")) (re.++ ((_ re.loop 0 1) (re.union (str.to_re " ") (str.to_re "-"))) (re.++ ((_ re.loop 1 1) (re.range "0" "9")) (re.++ ((_ re.loop 0 1) (re.union (str.to_re " ") (str.to_re "-"))) ((_ re.loop 3 3) (re.range "0" "9"))))))))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)