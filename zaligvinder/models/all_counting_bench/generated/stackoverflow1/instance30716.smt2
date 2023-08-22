;test regex ^([.]{0,2}|cgi-bin|recycle_bin)$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.union (re.union ((_ re.loop 0 2) (str.to_re ".")) (re.++ (str.to_re "c") (re.++ (str.to_re "g") (re.++ (str.to_re "i") (re.++ (str.to_re "-") (re.++ (str.to_re "b") (re.++ (str.to_re "i") (str.to_re "n")))))))) (re.++ (str.to_re "r") (re.++ (str.to_re "e") (re.++ (str.to_re "c") (re.++ (str.to_re "y") (re.++ (str.to_re "c") (re.++ (str.to_re "l") (re.++ (str.to_re "e") (re.++ (str.to_re "_") (re.++ (str.to_re "b") (re.++ (str.to_re "i") (str.to_re "n"))))))))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)