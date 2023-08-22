;test regex (0|\\+98 | 98)?([ ]|,|-|[()]){0,2}9[1|2|3|4]([ ]|,|-|[()]){0,2}(?:[0-9]([ ]|,|-|[()]){0,2}){8}
(declare-const X String)
(assert (str.in_re X (re.++ (re.opt (re.union (re.union (str.to_re "0") (re.++ (re.+ (str.to_re "\\")) (re.++ (str.to_re "98") (str.to_re " ")))) (re.++ (str.to_re " ") (str.to_re "98")))) (re.++ ((_ re.loop 0 2) (re.union (re.union (re.union (str.to_re " ") (str.to_re ",")) (str.to_re "-")) (re.union (str.to_re "(") (str.to_re ")")))) (re.++ (str.to_re "9") (re.++ (re.union (str.to_re "1") (re.union (str.to_re "|") (re.union (str.to_re "2") (re.union (str.to_re "|") (re.union (str.to_re "3") (re.union (str.to_re "|") (str.to_re "4"))))))) (re.++ ((_ re.loop 0 2) (re.union (re.union (re.union (str.to_re " ") (str.to_re ",")) (str.to_re "-")) (re.union (str.to_re "(") (str.to_re ")")))) ((_ re.loop 8 8) (re.++ (re.range "0" "9") ((_ re.loop 0 2) (re.union (re.union (re.union (str.to_re " ") (str.to_re ",")) (str.to_re "-")) (re.union (str.to_re "(") (str.to_re ")")))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)