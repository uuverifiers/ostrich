;test regex (((C|H).{6})|(KK.{8}))
(declare-const X String)
(assert (str.in_re X (re.union (re.++ (re.union (str.to_re "C") (str.to_re "H")) ((_ re.loop 6 6) (re.diff re.allchar (str.to_re "\n")))) (re.++ (str.to_re "K") (re.++ (str.to_re "K") ((_ re.loop 8 8) (re.diff re.allchar (str.to_re "\n"))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)