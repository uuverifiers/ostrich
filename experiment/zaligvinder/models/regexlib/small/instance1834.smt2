;test regex ^([V|E|J|G|v|e|j|g])([0-9]{5,8})$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ (re.union (str.to_re "V") (re.union (str.to_re "|") (re.union (str.to_re "E") (re.union (str.to_re "|") (re.union (str.to_re "J") (re.union (str.to_re "|") (re.union (str.to_re "G") (re.union (str.to_re "|") (re.union (str.to_re "v") (re.union (str.to_re "|") (re.union (str.to_re "e") (re.union (str.to_re "|") (re.union (str.to_re "j") (re.union (str.to_re "|") (str.to_re "g"))))))))))))))) ((_ re.loop 5 8) (re.range "0" "9")))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)