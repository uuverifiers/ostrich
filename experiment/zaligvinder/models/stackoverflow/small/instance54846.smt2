;test regex ((\d|[1-9]\d|1[0-4]\d|15[0-4])(\.\d{2})?|155(\.00)?)
(declare-const X String)
(assert (str.in_re X (re.union (re.++ (re.union (re.union (re.union (re.range "0" "9") (re.++ (re.range "1" "9") (re.range "0" "9"))) (re.++ (str.to_re "1") (re.++ (re.range "0" "4") (re.range "0" "9")))) (re.++ (str.to_re "15") (re.range "0" "4"))) (re.opt (re.++ (str.to_re ".") ((_ re.loop 2 2) (re.range "0" "9"))))) (re.++ (str.to_re "155") (re.opt (re.++ (str.to_re ".") (str.to_re "00")))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)