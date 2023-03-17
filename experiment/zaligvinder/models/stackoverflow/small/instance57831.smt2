;test regex "([0-9]{1,2}|100):(1?[0-9]{1,2}|200)"
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "\u{22}") (re.++ (re.union ((_ re.loop 1 2) (re.range "0" "9")) (str.to_re "100")) (re.++ (str.to_re ":") (re.++ (re.union (re.++ (re.opt (str.to_re "1")) ((_ re.loop 1 2) (re.range "0" "9"))) (str.to_re "200")) (str.to_re "\u{22}")))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)