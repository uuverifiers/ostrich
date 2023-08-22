;test regex (?:Name.+)(?:\n.*){2}
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "N") (re.++ (str.to_re "a") (re.++ (str.to_re "m") (re.++ (str.to_re "e") (re.+ (re.diff re.allchar (str.to_re "\n"))))))) ((_ re.loop 2 2) (re.++ (str.to_re "\u{0a}") (re.* (re.diff re.allchar (str.to_re "\n"))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)