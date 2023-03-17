;test regex ([\w ]{6})((\d{2})(\d{2})(\d{2}))([PC])(\d{8})
(declare-const X String)
(assert (str.in_re X (re.++ ((_ re.loop 6 6) (re.union (re.union (re.range "a" "z") (re.union (re.range "A" "Z") (re.union (re.range "0" "9") (str.to_re "_")))) (str.to_re " "))) (re.++ (re.++ ((_ re.loop 2 2) (re.range "0" "9")) (re.++ ((_ re.loop 2 2) (re.range "0" "9")) ((_ re.loop 2 2) (re.range "0" "9")))) (re.++ (re.union (str.to_re "P") (str.to_re "C")) ((_ re.loop 8 8) (re.range "0" "9")))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)