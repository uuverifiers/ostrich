;test regex ^(?:popup){0,1}?\|?(?:email){0,1}?\|?(?:webhook){0,1}?$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ ((_ re.loop 0 1) (re.++ (str.to_re "p") (re.++ (str.to_re "o") (re.++ (str.to_re "p") (re.++ (str.to_re "u") (str.to_re "p")))))) (re.++ (re.opt (str.to_re "|")) (re.++ ((_ re.loop 0 1) (re.++ (str.to_re "e") (re.++ (str.to_re "m") (re.++ (str.to_re "a") (re.++ (str.to_re "i") (str.to_re "l")))))) (re.++ (re.opt (str.to_re "|")) ((_ re.loop 0 1) (re.++ (str.to_re "w") (re.++ (str.to_re "e") (re.++ (str.to_re "b") (re.++ (str.to_re "h") (re.++ (str.to_re "o") (re.++ (str.to_re "o") (str.to_re "k"))))))))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)