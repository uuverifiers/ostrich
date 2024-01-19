;test regex "\\d{4}(-|\/)((0\\d)|(1[012]))(-|\/)(([012]\\d)|3[01])$" //^ removed, \/ added
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (re.++ (re.++ (str.to_re "\u{22}") (re.++ (str.to_re "\\") (re.++ ((_ re.loop 4 4) (str.to_re "d")) (re.++ (re.union (str.to_re "-") (str.to_re "/")) (re.++ (re.union (re.++ (str.to_re "0") (re.++ (str.to_re "\\") (str.to_re "d"))) (re.++ (str.to_re "1") (str.to_re "012"))) (re.++ (re.union (str.to_re "-") (str.to_re "/")) (re.union (re.++ (str.to_re "012") (re.++ (str.to_re "\\") (str.to_re "d"))) (re.++ (str.to_re "3") (str.to_re "01"))))))))) (re.++ (str.to_re "") (re.++ (str.to_re "\u{22}") (re.++ (str.to_re " ") (re.++ (str.to_re "/") (str.to_re "/")))))) (re.++ (str.to_re "") (re.++ (str.to_re " ") (re.++ (str.to_re "r") (re.++ (str.to_re "e") (re.++ (str.to_re "m") (re.++ (str.to_re "o") (re.++ (str.to_re "v") (re.++ (str.to_re "e") (str.to_re "d")))))))))) (re.++ (str.to_re ",") (re.++ (str.to_re " ") (re.++ (str.to_re "/") (re.++ (str.to_re " ") (re.++ (str.to_re "a") (re.++ (str.to_re "d") (re.++ (str.to_re "d") (re.++ (str.to_re "e") (str.to_re "d"))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)