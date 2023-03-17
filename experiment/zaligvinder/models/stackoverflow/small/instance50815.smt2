;test regex (cm|c.{0,1}?m|c.{0,2}?m)
(declare-const X String)
(assert (str.in_re X (re.union (re.union (re.++ (str.to_re "c") (str.to_re "m")) (re.++ (str.to_re "c") (re.++ ((_ re.loop 0 1) (re.diff re.allchar (str.to_re "\n"))) (str.to_re "m")))) (re.++ (str.to_re "c") (re.++ ((_ re.loop 0 2) (re.diff re.allchar (str.to_re "\n"))) (str.to_re "m"))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)