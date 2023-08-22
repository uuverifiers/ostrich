;test regex /^(19[0-9]{2}|2[0-9]{3})-(0[1-9]|1[012])-([123]0|[012][1-9]|31)[ \/T\/t]([01][0-9]|2[0-3]):([0-5][0-9]):([0-5][0-9])$/
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "/") (re.++ (str.to_re "") (re.++ (re.union (re.++ (str.to_re "19") ((_ re.loop 2 2) (re.range "0" "9"))) (re.++ (str.to_re "2") ((_ re.loop 3 3) (re.range "0" "9")))) (re.++ (str.to_re "-") (re.++ (re.union (re.++ (str.to_re "0") (re.range "1" "9")) (re.++ (str.to_re "1") (str.to_re "012"))) (re.++ (str.to_re "-") (re.++ (re.union (re.union (re.++ (str.to_re "123") (str.to_re "0")) (re.++ (str.to_re "012") (re.range "1" "9"))) (str.to_re "31")) (re.++ (re.union (str.to_re " ") (re.union (str.to_re "/") (re.union (str.to_re "T") (re.union (str.to_re "/") (str.to_re "t"))))) (re.++ (re.union (re.++ (str.to_re "01") (re.range "0" "9")) (re.++ (str.to_re "2") (re.range "0" "3"))) (re.++ (str.to_re ":") (re.++ (re.++ (re.range "0" "5") (re.range "0" "9")) (re.++ (str.to_re ":") (re.++ (re.range "0" "5") (re.range "0" "9")))))))))))))) (re.++ (str.to_re "") (str.to_re "/")))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)