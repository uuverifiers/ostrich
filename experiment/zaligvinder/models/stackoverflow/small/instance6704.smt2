;test regex Pattern.compile("^(0047|\+47|47)?[2-9]\d{7}$")
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "P") (re.++ (str.to_re "a") (re.++ (str.to_re "t") (re.++ (str.to_re "t") (re.++ (str.to_re "e") (re.++ (str.to_re "r") (re.++ (str.to_re "n") (re.++ (re.diff re.allchar (str.to_re "\n")) (re.++ (str.to_re "c") (re.++ (str.to_re "o") (re.++ (str.to_re "m") (re.++ (str.to_re "p") (re.++ (str.to_re "i") (re.++ (str.to_re "l") (re.++ (str.to_re "e") (re.++ (re.++ (str.to_re "\u{22}") (re.++ (str.to_re "") (re.++ (re.opt (re.union (re.union (str.to_re "0047") (re.++ (str.to_re "+") (str.to_re "47"))) (str.to_re "47"))) (re.++ (re.range "2" "9") ((_ re.loop 7 7) (re.range "0" "9")))))) (re.++ (str.to_re "") (str.to_re "\u{22}"))))))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)