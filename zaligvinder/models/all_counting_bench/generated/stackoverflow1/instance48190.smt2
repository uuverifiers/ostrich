;test regex ^((0[1-9]|[12][0-9]|3[01])-(0[1-9]|1[012])-\d{4} (20|21|22|23|[01]\d|\d)(([:][0-5]\d){1,2})( (AM|PM))?)$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ (re.union (re.union (re.++ (str.to_re "0") (re.range "1" "9")) (re.++ (str.to_re "12") (re.range "0" "9"))) (re.++ (str.to_re "3") (str.to_re "01"))) (re.++ (str.to_re "-") (re.++ (re.union (re.++ (str.to_re "0") (re.range "1" "9")) (re.++ (str.to_re "1") (str.to_re "012"))) (re.++ (str.to_re "-") (re.++ ((_ re.loop 4 4) (re.range "0" "9")) (re.++ (str.to_re " ") (re.++ (re.union (re.union (re.union (re.union (re.union (str.to_re "20") (str.to_re "21")) (str.to_re "22")) (str.to_re "23")) (re.++ (str.to_re "01") (re.range "0" "9"))) (re.range "0" "9")) (re.++ ((_ re.loop 1 2) (re.++ (str.to_re ":") (re.++ (re.range "0" "5") (re.range "0" "9")))) (re.opt (re.++ (str.to_re " ") (re.union (re.++ (str.to_re "A") (str.to_re "M")) (re.++ (str.to_re "P") (str.to_re "M")))))))))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)