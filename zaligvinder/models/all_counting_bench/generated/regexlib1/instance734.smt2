;test regex ^(\+27|27)?(\()?0?[87][23467](\))?( |-|\.|_)?(\d{3})( |-|\.|_)?(\d{4})
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "") (re.++ (re.opt (re.union (re.++ (str.to_re "+") (str.to_re "27")) (str.to_re "27"))) (re.++ (re.opt (str.to_re "(")) (re.++ (re.opt (str.to_re "0")) (re.++ (str.to_re "87") (re.++ (str.to_re "23467") (re.++ (re.opt (str.to_re ")")) (re.++ (re.opt (re.union (re.union (re.union (str.to_re " ") (str.to_re "-")) (str.to_re ".")) (str.to_re "_"))) (re.++ ((_ re.loop 3 3) (re.range "0" "9")) (re.++ (re.opt (re.union (re.union (re.union (str.to_re " ") (str.to_re "-")) (str.to_re ".")) (str.to_re "_"))) ((_ re.loop 4 4) (re.range "0" "9"))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)