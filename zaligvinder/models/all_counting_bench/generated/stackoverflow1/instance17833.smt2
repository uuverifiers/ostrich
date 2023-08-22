;test regex match(r'^[a-zA-Z][a-zA-Z0-9.-]{8,48}[a-zA-Z0-9]$', str)
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "m") (re.++ (str.to_re "a") (re.++ (str.to_re "t") (re.++ (str.to_re "c") (re.++ (str.to_re "h") (re.++ (re.++ (re.++ (re.++ (str.to_re "r") (str.to_re "\u{27}")) (re.++ (str.to_re "") (re.++ (re.union (re.range "a" "z") (re.range "A" "Z")) (re.++ ((_ re.loop 8 48) (re.union (re.range "a" "z") (re.union (re.range "A" "Z") (re.union (re.range "0" "9") (re.union (str.to_re ".") (str.to_re "-")))))) (re.union (re.range "a" "z") (re.union (re.range "A" "Z") (re.range "0" "9"))))))) (re.++ (str.to_re "") (str.to_re "\u{27}"))) (re.++ (str.to_re ",") (re.++ (str.to_re " ") (re.++ (str.to_re "s") (re.++ (str.to_re "t") (str.to_re "r")))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)