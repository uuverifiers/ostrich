;test regex (^([Aa][Ss])[0-9]{8})|(^6[0-9]{7})
(declare-const X String)
(assert (str.in_re X (re.union (re.++ (str.to_re "") (re.++ (re.++ (re.union (str.to_re "A") (str.to_re "a")) (re.union (str.to_re "S") (str.to_re "s"))) ((_ re.loop 8 8) (re.range "0" "9")))) (re.++ (str.to_re "") (re.++ (str.to_re "6") ((_ re.loop 7 7) (re.range "0" "9")))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)