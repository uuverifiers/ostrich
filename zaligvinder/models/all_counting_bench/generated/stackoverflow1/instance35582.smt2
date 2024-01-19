;test regex http(s)?:\/\/(www\.)?[a-zA-Z0-9-\.]+\.[a-z]{2,6}\/(\?p=|doc\/)[a-z0-9]+
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "h") (re.++ (str.to_re "t") (re.++ (str.to_re "t") (re.++ (str.to_re "p") (re.++ (re.opt (str.to_re "s")) (re.++ (str.to_re ":") (re.++ (str.to_re "/") (re.++ (str.to_re "/") (re.++ (re.opt (re.++ (str.to_re "w") (re.++ (str.to_re "w") (re.++ (str.to_re "w") (str.to_re "."))))) (re.++ (re.+ (re.union (re.range "a" "z") (re.union (re.range "A" "Z") (re.union (re.range "0" "9") (re.union (str.to_re "-") (str.to_re ".")))))) (re.++ (str.to_re ".") (re.++ ((_ re.loop 2 6) (re.range "a" "z")) (re.++ (str.to_re "/") (re.++ (re.union (re.++ (str.to_re "?") (re.++ (str.to_re "p") (str.to_re "="))) (re.++ (str.to_re "d") (re.++ (str.to_re "o") (re.++ (str.to_re "c") (str.to_re "/"))))) (re.+ (re.union (re.range "a" "z") (re.range "0" "9")))))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)