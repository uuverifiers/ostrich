;test regex ^(?:[cC][rR][0-9]{10}|[0-9]{5,7})(?:, (?:[cC][rR][0-9]{10}|[0-9]{5,7}))*$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ (re.union (re.++ (re.union (str.to_re "c") (str.to_re "C")) (re.++ (re.union (str.to_re "r") (str.to_re "R")) ((_ re.loop 10 10) (re.range "0" "9")))) ((_ re.loop 5 7) (re.range "0" "9"))) (re.* (re.++ (str.to_re ",") (re.++ (str.to_re " ") (re.union (re.++ (re.union (str.to_re "c") (str.to_re "C")) (re.++ (re.union (str.to_re "r") (str.to_re "R")) ((_ re.loop 10 10) (re.range "0" "9")))) ((_ re.loop 5 7) (re.range "0" "9")))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)