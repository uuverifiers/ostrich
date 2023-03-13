;test regex "^[a-zA-Z$%&]{3,4}(\d{6})((\D|\d){3})?$"
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "\u{22}") (re.++ (str.to_re "") (re.++ ((_ re.loop 3 4) (re.union (re.range "a" "z") (re.union (re.range "A" "Z") (re.union (str.to_re "$") (re.union (str.to_re "%") (str.to_re "&")))))) (re.++ ((_ re.loop 6 6) (re.range "0" "9")) (re.opt ((_ re.loop 3 3) (re.union (re.diff re.allchar (re.range "0" "9")) (re.range "0" "9")))))))) (re.++ (str.to_re "") (str.to_re "\u{22}")))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)