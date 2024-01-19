;test regex "v.{0,3}i.{0,3}a.{0,3}g.{0,3}r.{0,3}a"
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "\u{22}") (re.++ (str.to_re "v") (re.++ ((_ re.loop 0 3) (re.diff re.allchar (str.to_re "\n"))) (re.++ (str.to_re "i") (re.++ ((_ re.loop 0 3) (re.diff re.allchar (str.to_re "\n"))) (re.++ (str.to_re "a") (re.++ ((_ re.loop 0 3) (re.diff re.allchar (str.to_re "\n"))) (re.++ (str.to_re "g") (re.++ ((_ re.loop 0 3) (re.diff re.allchar (str.to_re "\n"))) (re.++ (str.to_re "r") (re.++ ((_ re.loop 0 3) (re.diff re.allchar (str.to_re "\n"))) (re.++ (str.to_re "a") (str.to_re "\u{22}")))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)