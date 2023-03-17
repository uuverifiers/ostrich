;test regex ^(?:[2-9]\d|[1-2]\d{2})(?:[.,]\d{1,2})?$|^300(?:[.,]0{1,2})?$
(declare-const X String)
(assert (str.in_re X (re.union (re.++ (re.++ (str.to_re "") (re.++ (re.union (re.++ (re.range "2" "9") (re.range "0" "9")) (re.++ (re.range "1" "2") ((_ re.loop 2 2) (re.range "0" "9")))) (re.opt (re.++ (re.union (str.to_re ".") (str.to_re ",")) ((_ re.loop 1 2) (re.range "0" "9")))))) (str.to_re "")) (re.++ (re.++ (str.to_re "") (re.++ (str.to_re "300") (re.opt (re.++ (re.union (str.to_re ".") (str.to_re ",")) ((_ re.loop 1 2) (str.to_re "0")))))) (str.to_re "")))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)