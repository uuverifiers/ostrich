;test regex ^\\d{1,3}(?:k|rb|ribu|(?:\\.\\d{3})+|\\d+)$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ (str.to_re "\\") (re.++ ((_ re.loop 1 3) (str.to_re "d")) (re.union (re.union (re.union (re.union (str.to_re "k") (re.++ (str.to_re "r") (str.to_re "b"))) (re.++ (str.to_re "r") (re.++ (str.to_re "i") (re.++ (str.to_re "b") (str.to_re "u"))))) (re.+ (re.++ (str.to_re "\\") (re.++ (re.diff re.allchar (str.to_re "\n")) (re.++ (str.to_re "\\") ((_ re.loop 3 3) (str.to_re "d"))))))) (re.++ (str.to_re "\\") (re.+ (str.to_re "d"))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)