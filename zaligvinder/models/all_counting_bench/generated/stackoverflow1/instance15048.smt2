;test regex str_match(x,"([A-Z][a-z]+\\s[0-9]{2})([^0-9]+)([0-9,\\.]+$)")
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "s") (re.++ (str.to_re "t") (re.++ (str.to_re "r") (re.++ (str.to_re "_") (re.++ (str.to_re "m") (re.++ (str.to_re "a") (re.++ (str.to_re "t") (re.++ (str.to_re "c") (re.++ (str.to_re "h") (re.++ (str.to_re "x") (re.++ (str.to_re ",") (re.++ (str.to_re "\u{22}") (re.++ (re.++ (re.range "A" "Z") (re.++ (re.+ (re.range "a" "z")) (re.++ (str.to_re "\\") (re.++ (str.to_re "s") ((_ re.loop 2 2) (re.range "0" "9")))))) (re.++ (re.+ (re.diff re.allchar (re.range "0" "9"))) (re.++ (re.++ (re.+ (re.union (re.range "0" "9") (re.union (str.to_re ",") (re.union (str.to_re "\\") (str.to_re "."))))) (str.to_re "")) (str.to_re "\u{22}"))))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)