;test regex [XYZ]{15}[WXY]{15}
(declare-const X String)
(assert (str.in_re X (re.++ ((_ re.loop 15 15) (re.union (str.to_re "X") (re.union (str.to_re "Y") (str.to_re "Z")))) ((_ re.loop 15 15) (re.union (str.to_re "W") (re.union (str.to_re "X") (str.to_re "Y")))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)