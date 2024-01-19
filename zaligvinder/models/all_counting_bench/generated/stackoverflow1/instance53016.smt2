;test regex 0?4(12|14|16|24|26)[0-9]{7}
(declare-const X String)
(assert (str.in_re X (re.++ (re.opt (str.to_re "0")) (re.++ (str.to_re "4") (re.++ (re.union (re.union (re.union (re.union (str.to_re "12") (str.to_re "14")) (str.to_re "16")) (str.to_re "24")) (str.to_re "26")) ((_ re.loop 7 7) (re.range "0" "9")))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)