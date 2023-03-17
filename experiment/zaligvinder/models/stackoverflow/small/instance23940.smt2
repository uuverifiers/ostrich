;test regex .replaceAll("\\b(\\d{2})(\\d+)-(\\d)$", "$1-$2$3")
(declare-const X String)
(assert (str.in_re X (re.++ (re.diff re.allchar (str.to_re "\n")) (re.++ (str.to_re "r") (re.++ (str.to_re "e") (re.++ (str.to_re "p") (re.++ (str.to_re "l") (re.++ (str.to_re "a") (re.++ (str.to_re "c") (re.++ (str.to_re "e") (re.++ (str.to_re "A") (re.++ (str.to_re "l") (re.++ (str.to_re "l") (re.++ (re.++ (re.++ (re.++ (re.++ (re.++ (str.to_re "\u{22}") (re.++ (str.to_re "\\") (re.++ (str.to_re "b") (re.++ (re.++ (str.to_re "\\") ((_ re.loop 2 2) (str.to_re "d"))) (re.++ (re.++ (str.to_re "\\") (re.+ (str.to_re "d"))) (re.++ (str.to_re "-") (re.++ (str.to_re "\\") (str.to_re "d")))))))) (re.++ (str.to_re "") (str.to_re "\u{22}"))) (re.++ (str.to_re ",") (re.++ (str.to_re " ") (str.to_re "\u{22}")))) (re.++ (str.to_re "") (re.++ (str.to_re "1") (str.to_re "-")))) (re.++ (str.to_re "") (str.to_re "2"))) (re.++ (str.to_re "") (re.++ (str.to_re "3") (str.to_re "\u{22}")))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)