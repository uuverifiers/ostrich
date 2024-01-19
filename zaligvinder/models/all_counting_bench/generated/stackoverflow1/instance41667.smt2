;test regex (\d\d{0,2})(((,\d{3}){0,2})|(\d{0,6}))( USD)?
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (re.range "0" "9") ((_ re.loop 0 2) (re.range "0" "9"))) (re.++ (re.union ((_ re.loop 0 2) (re.++ (str.to_re ",") ((_ re.loop 3 3) (re.range "0" "9")))) ((_ re.loop 0 6) (re.range "0" "9"))) (re.opt (re.++ (str.to_re " ") (re.++ (str.to_re "U") (re.++ (str.to_re "S") (str.to_re "D")))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)