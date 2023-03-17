;test regex ^(1[4-9]|[2-9]\d|\d{3,}) days, \d+ hours, \d+ minutes
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (re.++ (str.to_re "") (re.++ (re.union (re.union (re.++ (str.to_re "1") (re.range "4" "9")) (re.++ (re.range "2" "9") (re.range "0" "9"))) (re.++ (re.* (re.range "0" "9")) ((_ re.loop 3 3) (re.range "0" "9")))) (re.++ (str.to_re " ") (re.++ (str.to_re "d") (re.++ (str.to_re "a") (re.++ (str.to_re "y") (str.to_re "s"))))))) (re.++ (str.to_re ",") (re.++ (str.to_re " ") (re.++ (re.+ (re.range "0" "9")) (re.++ (str.to_re " ") (re.++ (str.to_re "h") (re.++ (str.to_re "o") (re.++ (str.to_re "u") (re.++ (str.to_re "r") (str.to_re "s")))))))))) (re.++ (str.to_re ",") (re.++ (str.to_re " ") (re.++ (re.+ (re.range "0" "9")) (re.++ (str.to_re " ") (re.++ (str.to_re "m") (re.++ (str.to_re "i") (re.++ (str.to_re "n") (re.++ (str.to_re "u") (re.++ (str.to_re "t") (re.++ (str.to_re "e") (str.to_re "s"))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)