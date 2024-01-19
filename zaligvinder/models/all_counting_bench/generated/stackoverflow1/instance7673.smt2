;test regex '^(w{3}\.)?([0-9A-Za-z-]+\.){1}' + domainName + '$'
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "\u{27}") (re.++ (str.to_re "") (re.++ (re.opt (re.++ ((_ re.loop 3 3) (str.to_re "w")) (str.to_re "."))) (re.++ ((_ re.loop 1 1) (re.++ (re.+ (re.union (re.range "0" "9") (re.union (re.range "A" "Z") (re.union (re.range "a" "z") (str.to_re "-"))))) (str.to_re "."))) (re.++ (str.to_re "\u{27}") (re.++ (re.+ (str.to_re " ")) (re.++ (str.to_re " ") (re.++ (str.to_re "d") (re.++ (str.to_re "o") (re.++ (str.to_re "m") (re.++ (str.to_re "a") (re.++ (str.to_re "i") (re.++ (str.to_re "n") (re.++ (str.to_re "N") (re.++ (str.to_re "a") (re.++ (str.to_re "m") (re.++ (str.to_re "e") (re.++ (re.+ (str.to_re " ")) (re.++ (str.to_re " ") (str.to_re "\u{27}")))))))))))))))))))) (re.++ (str.to_re "") (str.to_re "\u{27}")))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)