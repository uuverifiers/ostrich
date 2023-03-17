;test regex ((reci:\r\n){2}subj:\r\n(body:.*\r\n){2}eomm:)(yes)
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ ((_ re.loop 2 2) (re.++ (str.to_re "r") (re.++ (str.to_re "e") (re.++ (str.to_re "c") (re.++ (str.to_re "i") (re.++ (str.to_re ":") (re.++ (str.to_re "\u{0d}") (str.to_re "\u{0a}")))))))) (re.++ (str.to_re "s") (re.++ (str.to_re "u") (re.++ (str.to_re "b") (re.++ (str.to_re "j") (re.++ (str.to_re ":") (re.++ (str.to_re "\u{0d}") (re.++ (str.to_re "\u{0a}") (re.++ ((_ re.loop 2 2) (re.++ (str.to_re "b") (re.++ (str.to_re "o") (re.++ (str.to_re "d") (re.++ (str.to_re "y") (re.++ (str.to_re ":") (re.++ (re.* (re.diff re.allchar (str.to_re "\n"))) (re.++ (str.to_re "\u{0d}") (str.to_re "\u{0a}"))))))))) (re.++ (str.to_re "e") (re.++ (str.to_re "o") (re.++ (str.to_re "m") (re.++ (str.to_re "m") (str.to_re ":")))))))))))))) (re.++ (str.to_re "y") (re.++ (str.to_re "e") (str.to_re "s"))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)