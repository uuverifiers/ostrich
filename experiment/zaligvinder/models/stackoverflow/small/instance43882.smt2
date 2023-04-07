;test regex "^(.{1,2}$|[^6].{2}|.[^6].|.{2}[^6]).*"
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "\u{22}") (re.++ (str.to_re "") (re.++ (re.union (re.union (re.union (re.++ ((_ re.loop 1 2) (re.diff re.allchar (str.to_re "\n"))) (str.to_re "")) (re.++ (re.diff re.allchar (str.to_re "6")) ((_ re.loop 2 2) (re.diff re.allchar (str.to_re "\n"))))) (re.++ (re.diff re.allchar (str.to_re "\n")) (re.++ (re.diff re.allchar (str.to_re "6")) (re.diff re.allchar (str.to_re "\n"))))) (re.++ ((_ re.loop 2 2) (re.diff re.allchar (str.to_re "\n"))) (re.diff re.allchar (str.to_re "6")))) (re.++ (re.* (re.diff re.allchar (str.to_re "\n"))) (str.to_re "\u{22}")))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)