;test regex /^[01]?\d\/(([0-2]?\d)|([3][01]))\/((199\d)|([2-9]\d{3}))$/
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "/") (re.++ (str.to_re "") (re.++ (re.opt (str.to_re "01")) (re.++ (re.range "0" "9") (re.++ (str.to_re "/") (re.++ (re.union (re.++ (re.opt (re.range "0" "2")) (re.range "0" "9")) (re.++ (str.to_re "3") (str.to_re "01"))) (re.++ (str.to_re "/") (re.union (re.++ (str.to_re "199") (re.range "0" "9")) (re.++ (re.range "2" "9") ((_ re.loop 3 3) (re.range "0" "9"))))))))))) (re.++ (str.to_re "") (str.to_re "/")))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)