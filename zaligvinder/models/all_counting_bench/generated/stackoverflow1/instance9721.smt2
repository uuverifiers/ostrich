;test regex @"${1}0$2$3"
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (re.++ (re.++ (str.to_re "@") (str.to_re "\u{22}")) (re.++ ((_ re.loop 1 1) (str.to_re "")) (str.to_re "0"))) (re.++ (str.to_re "") (str.to_re "2"))) (re.++ (str.to_re "") (re.++ (str.to_re "3") (str.to_re "\u{22}"))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)