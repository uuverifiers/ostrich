;test regex --- !ruby/regexp /\/\A[a-zA-Z0-9_\.]+@[a-zA-Z0-9-]+\.[a-zA-Z]{0,4}\z\/i/
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "-") (re.++ (str.to_re "-") (re.++ (str.to_re "-") (re.++ (str.to_re " ") (re.++ (str.to_re "!") (re.++ (str.to_re "r") (re.++ (str.to_re "u") (re.++ (str.to_re "b") (re.++ (str.to_re "y") (re.++ (str.to_re "/") (re.++ (str.to_re "r") (re.++ (str.to_re "e") (re.++ (str.to_re "g") (re.++ (str.to_re "e") (re.++ (str.to_re "x") (re.++ (str.to_re "p") (re.++ (str.to_re " ") (re.++ (str.to_re "/") (re.++ (str.to_re "/") (re.++ (str.to_re "A") (re.++ (re.+ (re.union (re.range "a" "z") (re.union (re.range "A" "Z") (re.union (re.range "0" "9") (re.union (str.to_re "_") (str.to_re ".")))))) (re.++ (str.to_re "@") (re.++ (re.+ (re.union (re.range "a" "z") (re.union (re.range "A" "Z") (re.union (re.range "0" "9") (str.to_re "-"))))) (re.++ (str.to_re ".") (re.++ ((_ re.loop 0 4) (re.union (re.range "a" "z") (re.range "A" "Z"))) (re.++ (str.to_re "z") (re.++ (str.to_re "/") (re.++ (str.to_re "i") (str.to_re "/")))))))))))))))))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)