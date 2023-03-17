;test regex ^(.{7}|.{9}|.{12}|.{13}|.{15})$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.union (re.union (re.union (re.union ((_ re.loop 7 7) (re.diff re.allchar (str.to_re "\n"))) ((_ re.loop 9 9) (re.diff re.allchar (str.to_re "\n")))) ((_ re.loop 12 12) (re.diff re.allchar (str.to_re "\n")))) ((_ re.loop 13 13) (re.diff re.allchar (str.to_re "\n")))) ((_ re.loop 15 15) (re.diff re.allchar (str.to_re "\n"))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 50 (str.len X)))
(check-sat)
(get-model)