;test regex /^10.\d{4,9}/[-._;()/:A-Z0-9]+$/i
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "/") (re.++ (str.to_re "") (re.++ (str.to_re "10") (re.++ (re.diff re.allchar (str.to_re "\n")) (re.++ ((_ re.loop 4 9) (re.range "0" "9")) (re.++ (str.to_re "/") (re.+ (re.union (str.to_re "-") (re.union (str.to_re ".") (re.union (str.to_re "_") (re.union (str.to_re ";") (re.union (str.to_re "(") (re.union (str.to_re ")") (re.union (str.to_re "/") (re.union (str.to_re ":") (re.union (re.range "A" "Z") (re.range "0" "9"))))))))))))))))) (re.++ (str.to_re "") (re.++ (str.to_re "/") (str.to_re "i"))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)