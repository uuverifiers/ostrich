;test regex ^([0-9](\.\d{1,2})?)|([1]\d{1,2}(\.\d{1,2})?)|([2][0-3](\.\d{1,2})?)|24$
(declare-const X String)
(assert (str.in_re X (re.union (re.union (re.union (re.++ (str.to_re "") (re.++ (re.range "0" "9") (re.opt (re.++ (str.to_re ".") ((_ re.loop 1 2) (re.range "0" "9")))))) (re.++ (str.to_re "1") (re.++ ((_ re.loop 1 2) (re.range "0" "9")) (re.opt (re.++ (str.to_re ".") ((_ re.loop 1 2) (re.range "0" "9"))))))) (re.++ (str.to_re "2") (re.++ (re.range "0" "3") (re.opt (re.++ (str.to_re ".") ((_ re.loop 1 2) (re.range "0" "9"))))))) (re.++ (str.to_re "24") (str.to_re "")))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)