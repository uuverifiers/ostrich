;test regex ^([a-zA-Z0-9._%+-]|[^\u{00}-\x7F])+?@([a-zA-Z0-9.-]|[^\u{00}-\x7F])+\.([a-zA-Z]|[^\u{00}-\x7F]){2,63}$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ (re.+ (re.union (re.union (re.range "a" "z") (re.union (re.range "A" "Z") (re.union (re.range "0" "9") (re.union (str.to_re ".") (re.union (str.to_re "_") (re.union (str.to_re "%") (re.union (str.to_re "+") (str.to_re "-")))))))) (re.diff re.allchar (re.range "\u{00}" "\u{7f}")))) (re.++ (str.to_re "@") (re.++ (re.+ (re.union (re.union (re.range "a" "z") (re.union (re.range "A" "Z") (re.union (re.range "0" "9") (re.union (str.to_re ".") (str.to_re "-"))))) (re.diff re.allchar (re.range "\u{00}" "\u{7f}")))) (re.++ (str.to_re ".") ((_ re.loop 2 63) (re.union (re.union (re.range "a" "z") (re.range "A" "Z")) (re.diff re.allchar (re.range "\u{00}" "\u{7f}"))))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 50 (str.len X)))
(check-sat)
(get-model)