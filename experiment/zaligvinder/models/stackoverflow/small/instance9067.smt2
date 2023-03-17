;test regex ^[IN]-?[A-Z]{0,2}?\\d{0,14}[A-Z]{0,1}
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "") (re.++ (re.union (str.to_re "I") (str.to_re "N")) (re.++ (re.opt (str.to_re "-")) (re.++ ((_ re.loop 0 2) (re.range "A" "Z")) (re.++ (str.to_re "\\") (re.++ ((_ re.loop 0 14) (str.to_re "d")) ((_ re.loop 0 1) (re.range "A" "Z"))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)