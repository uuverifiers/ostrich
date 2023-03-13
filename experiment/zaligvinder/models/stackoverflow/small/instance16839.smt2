;test regex '^([A-TV-Za-tv-z]{1}[0-9]{1}[A-Za-z0-9]{1}|[A-TV-Za-tv-z]{1}[0-9]{1}[A-Za-z0-9]{1}.[A-Za-z0-9]{1,4})$'
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "\u{27}") (re.++ (str.to_re "") (re.union (re.++ ((_ re.loop 1 1) (re.union (re.range "A" "T") (re.union (re.range "V" "Z") (re.union (re.range "a" "t") (re.range "v" "z"))))) (re.++ ((_ re.loop 1 1) (re.range "0" "9")) ((_ re.loop 1 1) (re.union (re.range "A" "Z") (re.union (re.range "a" "z") (re.range "0" "9")))))) (re.++ ((_ re.loop 1 1) (re.union (re.range "A" "T") (re.union (re.range "V" "Z") (re.union (re.range "a" "t") (re.range "v" "z"))))) (re.++ ((_ re.loop 1 1) (re.range "0" "9")) (re.++ ((_ re.loop 1 1) (re.union (re.range "A" "Z") (re.union (re.range "a" "z") (re.range "0" "9")))) (re.++ (re.diff re.allchar (str.to_re "\n")) ((_ re.loop 1 4) (re.union (re.range "A" "Z") (re.union (re.range "a" "z") (re.range "0" "9"))))))))))) (re.++ (str.to_re "") (str.to_re "\u{27}")))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)