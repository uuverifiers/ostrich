;test regex ipa=$(ifconfig | grep -A 1 eth0 | grep -Po "inet addr:(\d{1,3}\.){3}\d{1,3}" | cut -f2 -d:)
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "i") (re.++ (str.to_re "p") (re.++ (str.to_re "a") (str.to_re "=")))) (re.++ (str.to_re "") (re.union (re.union (re.union (re.++ (str.to_re "i") (re.++ (str.to_re "f") (re.++ (str.to_re "c") (re.++ (str.to_re "o") (re.++ (str.to_re "n") (re.++ (str.to_re "f") (re.++ (str.to_re "i") (re.++ (str.to_re "g") (str.to_re " "))))))))) (re.++ (str.to_re " ") (re.++ (str.to_re "g") (re.++ (str.to_re "r") (re.++ (str.to_re "e") (re.++ (str.to_re "p") (re.++ (str.to_re " ") (re.++ (str.to_re "-") (re.++ (str.to_re "A") (re.++ (str.to_re " ") (re.++ (str.to_re "1") (re.++ (str.to_re " ") (re.++ (str.to_re "e") (re.++ (str.to_re "t") (re.++ (str.to_re "h") (re.++ (str.to_re "0") (str.to_re " "))))))))))))))))) (re.++ (str.to_re " ") (re.++ (str.to_re "g") (re.++ (str.to_re "r") (re.++ (str.to_re "e") (re.++ (str.to_re "p") (re.++ (str.to_re " ") (re.++ (str.to_re "-") (re.++ (str.to_re "P") (re.++ (str.to_re "o") (re.++ (str.to_re " ") (re.++ (str.to_re "\u{22}") (re.++ (str.to_re "i") (re.++ (str.to_re "n") (re.++ (str.to_re "e") (re.++ (str.to_re "t") (re.++ (str.to_re " ") (re.++ (str.to_re "a") (re.++ (str.to_re "d") (re.++ (str.to_re "d") (re.++ (str.to_re "r") (re.++ (str.to_re ":") (re.++ ((_ re.loop 3 3) (re.++ ((_ re.loop 1 3) (re.range "0" "9")) (str.to_re "."))) (re.++ ((_ re.loop 1 3) (re.range "0" "9")) (re.++ (str.to_re "\u{22}") (str.to_re " ")))))))))))))))))))))))))) (re.++ (str.to_re " ") (re.++ (str.to_re "c") (re.++ (str.to_re "u") (re.++ (str.to_re "t") (re.++ (str.to_re " ") (re.++ (str.to_re "-") (re.++ (str.to_re "f") (re.++ (str.to_re "2") (re.++ (str.to_re " ") (re.++ (str.to_re "-") (re.++ (str.to_re "d") (str.to_re ":")))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)