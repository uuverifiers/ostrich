;test regex ((\+351|00351|351)?)(2\d{1}|(9(3|6|2|1)))\d{7}
(declare-const X String)
(assert (str.in_re X (re.++ (re.opt (re.union (re.union (re.++ (str.to_re "+") (str.to_re "351")) (str.to_re "00351")) (str.to_re "351"))) (re.++ (re.union (re.++ (str.to_re "2") ((_ re.loop 1 1) (re.range "0" "9"))) (re.++ (str.to_re "9") (re.union (re.union (re.union (str.to_re "3") (str.to_re "6")) (str.to_re "2")) (str.to_re "1")))) ((_ re.loop 7 7) (re.range "0" "9"))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)