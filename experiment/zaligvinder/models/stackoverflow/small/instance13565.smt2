;test regex .{13}0*([0-9]*)[0-9]{5}
(declare-const X String)
(assert (str.in_re X (re.++ ((_ re.loop 13 13) (re.diff re.allchar (str.to_re "\n"))) (re.++ (re.* (str.to_re "0")) (re.++ (re.* (re.range "0" "9")) ((_ re.loop 5 5) (re.range "0" "9")))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)