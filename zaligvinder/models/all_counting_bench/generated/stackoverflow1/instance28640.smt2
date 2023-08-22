;test regex <cfif Refind("^[0-9]{2}\/(201[5-9]|202[0-9]|203[0-9])$", Date) eq 1>
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "<") (re.++ (str.to_re "c") (re.++ (str.to_re "f") (re.++ (str.to_re "i") (re.++ (str.to_re "f") (re.++ (str.to_re " ") (re.++ (str.to_re "R") (re.++ (str.to_re "e") (re.++ (str.to_re "f") (re.++ (str.to_re "i") (re.++ (str.to_re "n") (re.++ (str.to_re "d") (re.++ (re.++ (re.++ (re.++ (str.to_re "\u{22}") (re.++ (str.to_re "") (re.++ ((_ re.loop 2 2) (re.range "0" "9")) (re.++ (str.to_re "/") (re.union (re.union (re.++ (str.to_re "201") (re.range "5" "9")) (re.++ (str.to_re "202") (re.range "0" "9"))) (re.++ (str.to_re "203") (re.range "0" "9"))))))) (re.++ (str.to_re "") (str.to_re "\u{22}"))) (re.++ (str.to_re ",") (re.++ (str.to_re " ") (re.++ (str.to_re "D") (re.++ (str.to_re "a") (re.++ (str.to_re "t") (str.to_re "e"))))))) (re.++ (str.to_re " ") (re.++ (str.to_re "e") (re.++ (str.to_re "q") (re.++ (str.to_re " ") (re.++ (str.to_re "1") (str.to_re ">")))))))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)