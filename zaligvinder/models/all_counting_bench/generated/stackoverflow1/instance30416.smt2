;test regex (.*?).\(?(\d{4})(.*?(color))?.*?(shape)(.*?(color))?(.*?(version))?.*
(declare-const X String)
(assert (str.in_re X (re.++ (re.* (re.diff re.allchar (str.to_re "\n"))) (re.++ (re.diff re.allchar (str.to_re "\n")) (re.++ (re.opt (str.to_re "(")) (re.++ ((_ re.loop 4 4) (re.range "0" "9")) (re.++ (re.opt (re.++ (re.* (re.diff re.allchar (str.to_re "\n"))) (re.++ (str.to_re "c") (re.++ (str.to_re "o") (re.++ (str.to_re "l") (re.++ (str.to_re "o") (str.to_re "r"))))))) (re.++ (re.* (re.diff re.allchar (str.to_re "\n"))) (re.++ (re.++ (str.to_re "s") (re.++ (str.to_re "h") (re.++ (str.to_re "a") (re.++ (str.to_re "p") (str.to_re "e"))))) (re.++ (re.opt (re.++ (re.* (re.diff re.allchar (str.to_re "\n"))) (re.++ (str.to_re "c") (re.++ (str.to_re "o") (re.++ (str.to_re "l") (re.++ (str.to_re "o") (str.to_re "r"))))))) (re.++ (re.opt (re.++ (re.* (re.diff re.allchar (str.to_re "\n"))) (re.++ (str.to_re "v") (re.++ (str.to_re "e") (re.++ (str.to_re "r") (re.++ (str.to_re "s") (re.++ (str.to_re "i") (re.++ (str.to_re "o") (str.to_re "n"))))))))) (re.* (re.diff re.allchar (str.to_re "\n"))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)