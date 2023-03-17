;test regex ^To:.[0123456789]{4}@mydomain.com$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ (str.to_re "T") (re.++ (str.to_re "o") (re.++ (str.to_re ":") (re.++ (re.diff re.allchar (str.to_re "\n")) (re.++ ((_ re.loop 4 4) (str.to_re "0123456789")) (re.++ (str.to_re "@") (re.++ (str.to_re "m") (re.++ (str.to_re "y") (re.++ (str.to_re "d") (re.++ (str.to_re "o") (re.++ (str.to_re "m") (re.++ (str.to_re "a") (re.++ (str.to_re "i") (re.++ (str.to_re "n") (re.++ (re.diff re.allchar (str.to_re "\n")) (re.++ (str.to_re "c") (re.++ (str.to_re "o") (str.to_re "m"))))))))))))))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)