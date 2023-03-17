;test regex pattern="^ *(\\d+) +((?:\\d+ +){5}[.0-9]+) +"
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "p") (re.++ (str.to_re "a") (re.++ (str.to_re "t") (re.++ (str.to_re "t") (re.++ (str.to_re "e") (re.++ (str.to_re "r") (re.++ (str.to_re "n") (re.++ (str.to_re "=") (str.to_re "\u{22}"))))))))) (re.++ (str.to_re "") (re.++ (re.* (str.to_re " ")) (re.++ (re.++ (str.to_re "\\") (re.+ (str.to_re "d"))) (re.++ (re.+ (str.to_re " ")) (re.++ (re.++ ((_ re.loop 5 5) (re.++ (str.to_re "\\") (re.++ (re.+ (str.to_re "d")) (re.+ (str.to_re " "))))) (re.+ (re.union (str.to_re ".") (re.range "0" "9")))) (re.++ (re.+ (str.to_re " ")) (str.to_re "\u{22}"))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)