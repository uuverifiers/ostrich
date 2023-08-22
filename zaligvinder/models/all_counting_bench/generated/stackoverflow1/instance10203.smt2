;test regex %r"\A(https?://)?[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]{2,6}(/.*)?\Z"i
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "%") (re.++ (str.to_re "r") (re.++ (str.to_re "\u{22}") (re.++ (str.to_re "A") (re.++ (re.opt (re.++ (str.to_re "h") (re.++ (str.to_re "t") (re.++ (str.to_re "t") (re.++ (str.to_re "p") (re.++ (re.opt (str.to_re "s")) (re.++ (str.to_re ":") (re.++ (str.to_re "/") (str.to_re "/"))))))))) (re.++ (re.+ (re.union (re.range "a" "z") (re.union (re.range "0" "9") (str.to_re "-")))) (re.++ (re.* (re.++ (str.to_re ".") (re.+ (re.union (re.range "a" "z") (re.union (re.range "0" "9") (str.to_re "-")))))) (re.++ (str.to_re ".") (re.++ ((_ re.loop 2 6) (re.range "a" "z")) (re.++ (re.opt (re.++ (str.to_re "/") (re.* (re.diff re.allchar (str.to_re "\n"))))) (re.++ (str.to_re "Z") (re.++ (str.to_re "\u{22}") (str.to_re "i")))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)