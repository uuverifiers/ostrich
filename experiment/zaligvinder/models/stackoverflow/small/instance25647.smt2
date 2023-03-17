;test regex (127\.0\.0\.1\:.+?\d{1,5})|(127\.0\.0\.1)
(declare-const X String)
(assert (str.in_re X (re.union (re.++ (str.to_re "127") (re.++ (str.to_re ".") (re.++ (str.to_re "0") (re.++ (str.to_re ".") (re.++ (str.to_re "0") (re.++ (str.to_re ".") (re.++ (str.to_re "1") (re.++ (str.to_re ":") (re.++ (re.+ (re.diff re.allchar (str.to_re "\n"))) ((_ re.loop 1 5) (re.range "0" "9"))))))))))) (re.++ (str.to_re "127") (re.++ (str.to_re ".") (re.++ (str.to_re "0") (re.++ (str.to_re ".") (re.++ (str.to_re "0") (re.++ (str.to_re ".") (str.to_re "1"))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)