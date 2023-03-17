;test regex "{0}","Hello World","{1}"
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (re.++ ((_ re.loop 0 0) (str.to_re "\u{22}")) (str.to_re "\u{22}")) (re.++ (str.to_re ",") (re.++ (str.to_re "\u{22}") (re.++ (str.to_re "H") (re.++ (str.to_re "e") (re.++ (str.to_re "l") (re.++ (str.to_re "l") (re.++ (str.to_re "o") (re.++ (str.to_re " ") (re.++ (str.to_re "W") (re.++ (str.to_re "o") (re.++ (str.to_re "r") (re.++ (str.to_re "l") (re.++ (str.to_re "d") (str.to_re "\u{22}"))))))))))))))) (re.++ (str.to_re ",") (re.++ ((_ re.loop 1 1) (str.to_re "\u{22}")) (str.to_re "\u{22}"))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)