;test regex (?:.{9}|.{0,9})that(?:.{9}|.{0,9})
(declare-const X String)
(assert (str.in_re X (re.++ (re.union ((_ re.loop 9 9) (re.diff re.allchar (str.to_re "\n"))) ((_ re.loop 0 9) (re.diff re.allchar (str.to_re "\n")))) (re.++ (str.to_re "t") (re.++ (str.to_re "h") (re.++ (str.to_re "a") (re.++ (str.to_re "t") (re.union ((_ re.loop 9 9) (re.diff re.allchar (str.to_re "\n"))) ((_ re.loop 0 9) (re.diff re.allchar (str.to_re "\n")))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)