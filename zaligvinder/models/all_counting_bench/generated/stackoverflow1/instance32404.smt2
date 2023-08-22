;test regex ^(([0123]\d?)|([0123]\d\/[01]?)|([0123]\d\/[01]\d\/?)|([0123]\d\/[01]\d\/(1|2|19\d{0,2}|20\d{0,2})))$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.union (re.union (re.union (re.++ (str.to_re "0123") (re.opt (re.range "0" "9"))) (re.++ (str.to_re "0123") (re.++ (re.range "0" "9") (re.++ (str.to_re "/") (re.opt (str.to_re "01")))))) (re.++ (str.to_re "0123") (re.++ (re.range "0" "9") (re.++ (str.to_re "/") (re.++ (str.to_re "01") (re.++ (re.range "0" "9") (re.opt (str.to_re "/")))))))) (re.++ (str.to_re "0123") (re.++ (re.range "0" "9") (re.++ (str.to_re "/") (re.++ (str.to_re "01") (re.++ (re.range "0" "9") (re.++ (str.to_re "/") (re.union (re.union (re.union (str.to_re "1") (str.to_re "2")) (re.++ (str.to_re "19") ((_ re.loop 0 2) (re.range "0" "9")))) (re.++ (str.to_re "20") ((_ re.loop 0 2) (re.range "0" "9")))))))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)