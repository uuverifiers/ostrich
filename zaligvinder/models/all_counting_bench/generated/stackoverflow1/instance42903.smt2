;test regex ^((01|12|23|34|45|56|67|78|89|90|09|98|87|76|65|54|43|32|21|10)0){2}$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") ((_ re.loop 2 2) (re.++ (re.union (re.union (re.union (re.union (re.union (re.union (re.union (re.union (re.union (re.union (re.union (re.union (re.union (re.union (re.union (re.union (re.union (re.union (re.union (str.to_re "01") (str.to_re "12")) (str.to_re "23")) (str.to_re "34")) (str.to_re "45")) (str.to_re "56")) (str.to_re "67")) (str.to_re "78")) (str.to_re "89")) (str.to_re "90")) (str.to_re "09")) (str.to_re "98")) (str.to_re "87")) (str.to_re "76")) (str.to_re "65")) (str.to_re "54")) (str.to_re "43")) (str.to_re "32")) (str.to_re "21")) (str.to_re "10")) (str.to_re "0")))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)