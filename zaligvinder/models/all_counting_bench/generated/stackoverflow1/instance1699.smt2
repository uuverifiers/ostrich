;test regex ^(?:([AE][0-9]{7})|(IN:\g<1>Q))$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.union (re.++ (re.union (str.to_re "A") (str.to_re "E")) ((_ re.loop 7 7) (re.range "0" "9"))) (re.++ (str.to_re "I") (re.++ (str.to_re "N") (re.++ (str.to_re ":") (re.++ (str.to_re "g") (re.++ (str.to_re "<") (re.++ (str.to_re "1") (re.++ (str.to_re ">") (str.to_re "Q")))))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)