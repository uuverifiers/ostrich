;test regex ^ban_[0-9a-z]{60}
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "") (re.++ (str.to_re "b") (re.++ (str.to_re "a") (re.++ (str.to_re "n") (re.++ (str.to_re "_") ((_ re.loop 60 60) (re.union (re.range "0" "9") (re.range "a" "z"))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)