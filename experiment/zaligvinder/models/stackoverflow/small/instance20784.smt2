;test regex ([a-z]+)_([0-9.\w]{3,})\.jpg
(declare-const X String)
(assert (str.in_re X (re.++ (re.+ (re.range "a" "z")) (re.++ (str.to_re "_") (re.++ (re.++ (re.* (re.union (re.range "0" "9") (re.union (str.to_re ".") (re.union (re.range "a" "z") (re.union (re.range "A" "Z") (re.union (re.range "0" "9") (str.to_re "_"))))))) ((_ re.loop 3 3) (re.union (re.range "0" "9") (re.union (str.to_re ".") (re.union (re.range "a" "z") (re.union (re.range "A" "Z") (re.union (re.range "0" "9") (str.to_re "_")))))))) (re.++ (str.to_re ".") (re.++ (str.to_re "j") (re.++ (str.to_re "p") (str.to_re "g")))))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)