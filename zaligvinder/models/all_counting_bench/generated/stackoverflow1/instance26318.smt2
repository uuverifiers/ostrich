;test regex ((2[0-5]{2}|1[0-9]{2}|[0-9]{1,2})\.){3}(2[0-5]{2}|1[0-9]{2}|[0-9]{1,2})
(declare-const X String)
(assert (str.in_re X (re.++ ((_ re.loop 3 3) (re.++ (re.union (re.union (re.++ (str.to_re "2") ((_ re.loop 2 2) (re.range "0" "5"))) (re.++ (str.to_re "1") ((_ re.loop 2 2) (re.range "0" "9")))) ((_ re.loop 1 2) (re.range "0" "9"))) (str.to_re "."))) (re.union (re.union (re.++ (str.to_re "2") ((_ re.loop 2 2) (re.range "0" "5"))) (re.++ (str.to_re "1") ((_ re.loop 2 2) (re.range "0" "9")))) ((_ re.loop 1 2) (re.range "0" "9"))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)