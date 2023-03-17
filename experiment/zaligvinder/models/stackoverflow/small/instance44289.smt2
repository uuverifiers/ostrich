;test regex (^7.{3}Y.{4}WA)|(^7.{3}M.{5})|(^7.{8}W)
(declare-const X String)
(assert (str.in_re X (re.union (re.union (re.++ (str.to_re "") (re.++ (str.to_re "7") (re.++ ((_ re.loop 3 3) (re.diff re.allchar (str.to_re "\n"))) (re.++ (str.to_re "Y") (re.++ ((_ re.loop 4 4) (re.diff re.allchar (str.to_re "\n"))) (re.++ (str.to_re "W") (str.to_re "A"))))))) (re.++ (str.to_re "") (re.++ (str.to_re "7") (re.++ ((_ re.loop 3 3) (re.diff re.allchar (str.to_re "\n"))) (re.++ (str.to_re "M") ((_ re.loop 5 5) (re.diff re.allchar (str.to_re "\n")))))))) (re.++ (str.to_re "") (re.++ (str.to_re "7") (re.++ ((_ re.loop 8 8) (re.diff re.allchar (str.to_re "\n"))) (str.to_re "W")))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)