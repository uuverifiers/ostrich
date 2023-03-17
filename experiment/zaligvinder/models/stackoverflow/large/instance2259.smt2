;test regex ".{0,20}error.{0,200}"
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "\u{22}") (re.++ ((_ re.loop 0 20) (re.diff re.allchar (str.to_re "\n"))) (re.++ (str.to_re "e") (re.++ (str.to_re "r") (re.++ (str.to_re "r") (re.++ (str.to_re "o") (re.++ (str.to_re "r") (re.++ ((_ re.loop 0 200) (re.diff re.allchar (str.to_re "\n"))) (str.to_re "\u{22}")))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 50 (str.len X)))
(check-sat)
(get-model)