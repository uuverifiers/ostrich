;test regex ((http|https)://)?([a-z0-9]+\.)?[a-z0-9\-_]+.[a-z]+(/[a-z0-9\-_]*)*([a-z0-9\-_]*\.[a-z]+){0,1}
(declare-const X String)
(assert (str.in_re X (re.++ (re.opt (re.++ (re.union (re.++ (str.to_re "h") (re.++ (str.to_re "t") (re.++ (str.to_re "t") (str.to_re "p")))) (re.++ (str.to_re "h") (re.++ (str.to_re "t") (re.++ (str.to_re "t") (re.++ (str.to_re "p") (str.to_re "s")))))) (re.++ (str.to_re ":") (re.++ (str.to_re "/") (str.to_re "/"))))) (re.++ (re.opt (re.++ (re.+ (re.union (re.range "a" "z") (re.range "0" "9"))) (str.to_re "."))) (re.++ (re.+ (re.union (re.range "a" "z") (re.union (re.range "0" "9") (re.union (str.to_re "-") (str.to_re "_"))))) (re.++ (re.diff re.allchar (str.to_re "\n")) (re.++ (re.+ (re.range "a" "z")) (re.++ (re.* (re.++ (str.to_re "/") (re.* (re.union (re.range "a" "z") (re.union (re.range "0" "9") (re.union (str.to_re "-") (str.to_re "_"))))))) ((_ re.loop 0 1) (re.++ (re.* (re.union (re.range "a" "z") (re.union (re.range "0" "9") (re.union (str.to_re "-") (str.to_re "_"))))) (re.++ (str.to_re ".") (re.+ (re.range "a" "z")))))))))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)