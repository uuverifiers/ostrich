;test regex (?:a(?:b(?:c(?:d)?)?)?ef(?:g(?:h(?:i)?)?)?jklmn){15,}
(declare-const X String)
(assert (str.in_re X (re.++ (re.* (re.++ (str.to_re "a") (re.++ (re.opt (re.++ (str.to_re "b") (re.opt (re.++ (str.to_re "c") (re.opt (str.to_re "d")))))) (re.++ (str.to_re "e") (re.++ (str.to_re "f") (re.++ (re.opt (re.++ (str.to_re "g") (re.opt (re.++ (str.to_re "h") (re.opt (str.to_re "i")))))) (re.++ (str.to_re "j") (re.++ (str.to_re "k") (re.++ (str.to_re "l") (re.++ (str.to_re "m") (str.to_re "n"))))))))))) ((_ re.loop 15 15) (re.++ (str.to_re "a") (re.++ (re.opt (re.++ (str.to_re "b") (re.opt (re.++ (str.to_re "c") (re.opt (str.to_re "d")))))) (re.++ (str.to_re "e") (re.++ (str.to_re "f") (re.++ (re.opt (re.++ (str.to_re "g") (re.opt (re.++ (str.to_re "h") (re.opt (str.to_re "i")))))) (re.++ (str.to_re "j") (re.++ (str.to_re "k") (re.++ (str.to_re "l") (re.++ (str.to_re "m") (str.to_re "n"))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)