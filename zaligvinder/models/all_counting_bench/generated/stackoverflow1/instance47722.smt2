;test regex replaceAll(".+\nTKT:(\\d{3})\\d{10}.+", "$1");
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "r") (re.++ (str.to_re "e") (re.++ (str.to_re "p") (re.++ (str.to_re "l") (re.++ (str.to_re "a") (re.++ (str.to_re "c") (re.++ (str.to_re "e") (re.++ (str.to_re "A") (re.++ (str.to_re "l") (re.++ (str.to_re "l") (re.++ (re.++ (re.++ (re.++ (str.to_re "\u{22}") (re.++ (re.+ (re.diff re.allchar (str.to_re "\n"))) (re.++ (str.to_re "\u{0a}") (re.++ (str.to_re "T") (re.++ (str.to_re "K") (re.++ (str.to_re "T") (re.++ (str.to_re ":") (re.++ (re.++ (str.to_re "\\") ((_ re.loop 3 3) (str.to_re "d"))) (re.++ (str.to_re "\\") (re.++ ((_ re.loop 10 10) (str.to_re "d")) (re.++ (re.+ (re.diff re.allchar (str.to_re "\n"))) (str.to_re "\u{22}")))))))))))) (re.++ (str.to_re ",") (re.++ (str.to_re " ") (str.to_re "\u{22}")))) (re.++ (str.to_re "") (re.++ (str.to_re "1") (str.to_re "\u{22}")))) (str.to_re ";"))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)