;test regex [a-zA-Z0-9_\.+]+@(gmail|yahoo|hotmail)(\.[a-z]{2,3}){1,2}
(declare-const X String)
(assert (str.in_re X (re.++ (re.+ (re.union (re.range "a" "z") (re.union (re.range "A" "Z") (re.union (re.range "0" "9") (re.union (str.to_re "_") (re.union (str.to_re ".") (str.to_re "+"))))))) (re.++ (str.to_re "@") (re.++ (re.union (re.union (re.++ (str.to_re "g") (re.++ (str.to_re "m") (re.++ (str.to_re "a") (re.++ (str.to_re "i") (str.to_re "l"))))) (re.++ (str.to_re "y") (re.++ (str.to_re "a") (re.++ (str.to_re "h") (re.++ (str.to_re "o") (str.to_re "o")))))) (re.++ (str.to_re "h") (re.++ (str.to_re "o") (re.++ (str.to_re "t") (re.++ (str.to_re "m") (re.++ (str.to_re "a") (re.++ (str.to_re "i") (str.to_re "l")))))))) ((_ re.loop 1 2) (re.++ (str.to_re ".") ((_ re.loop 2 3) (re.range "a" "z")))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)