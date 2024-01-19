;test regex ^([A-Z]{3}), ([A-Z]{3}), ([A-Z]{3}) ([A-Z][a-z].*)
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (re.++ (str.to_re "") ((_ re.loop 3 3) (re.range "A" "Z"))) (re.++ (str.to_re ",") (re.++ (str.to_re " ") ((_ re.loop 3 3) (re.range "A" "Z"))))) (re.++ (str.to_re ",") (re.++ (str.to_re " ") (re.++ ((_ re.loop 3 3) (re.range "A" "Z")) (re.++ (str.to_re " ") (re.++ (re.range "A" "Z") (re.++ (re.range "a" "z") (re.* (re.diff re.allchar (str.to_re "\n"))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)