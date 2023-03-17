;test regex ^(\d+(?:\.0*[1-9]{1,2})?).*$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ (re.++ (re.+ (re.range "0" "9")) (re.opt (re.++ (str.to_re ".") (re.++ (re.* (str.to_re "0")) ((_ re.loop 1 2) (re.range "1" "9")))))) (re.* (re.diff re.allchar (str.to_re "\n"))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)