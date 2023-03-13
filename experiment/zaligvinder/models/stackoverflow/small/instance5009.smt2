;test regex r'T.{18}(?:TT|AA|CC|GG)'
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "r") (re.++ (str.to_re "\u{27}") (re.++ (str.to_re "T") (re.++ ((_ re.loop 18 18) (re.diff re.allchar (str.to_re "\n"))) (re.++ (re.union (re.union (re.union (re.++ (str.to_re "T") (str.to_re "T")) (re.++ (str.to_re "A") (str.to_re "A"))) (re.++ (str.to_re "C") (str.to_re "C"))) (re.++ (str.to_re "G") (str.to_re "G"))) (str.to_re "\u{27}"))))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)