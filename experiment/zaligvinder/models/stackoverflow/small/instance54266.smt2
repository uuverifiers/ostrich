;test regex ^(?:[^_\n]+_){3}([0-9A-Za-z]+)(?:_[^_\n]+)*$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ ((_ re.loop 3 3) (re.++ (re.+ (re.inter (re.diff re.allchar (str.to_re "_")) (re.diff re.allchar (str.to_re "\u{0a}")))) (str.to_re "_"))) (re.++ (re.+ (re.union (re.range "0" "9") (re.union (re.range "A" "Z") (re.range "a" "z")))) (re.* (re.++ (str.to_re "_") (re.+ (re.inter (re.diff re.allchar (str.to_re "_")) (re.diff re.allchar (str.to_re "\u{0a}"))))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)