;test regex ^[fadtFADT]{65}$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") ((_ re.loop 65 65) (re.union (str.to_re "f") (re.union (str.to_re "a") (re.union (str.to_re "d") (re.union (str.to_re "t") (re.union (str.to_re "F") (re.union (str.to_re "A") (re.union (str.to_re "D") (str.to_re "T")))))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 50 (str.len X)))
(check-sat)
(get-model)