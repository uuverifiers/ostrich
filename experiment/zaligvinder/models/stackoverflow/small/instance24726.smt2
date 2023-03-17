;test regex (at|in|of)( \w+){0,2} [A-Z](?:\w+)?
(declare-const X String)
(assert (str.in_re X (re.++ (re.union (re.union (re.++ (str.to_re "a") (str.to_re "t")) (re.++ (str.to_re "i") (str.to_re "n"))) (re.++ (str.to_re "o") (str.to_re "f"))) (re.++ ((_ re.loop 0 2) (re.++ (str.to_re " ") (re.+ (re.union (re.range "a" "z") (re.union (re.range "A" "Z") (re.union (re.range "0" "9") (str.to_re "_"))))))) (re.++ (str.to_re " ") (re.++ (re.range "A" "Z") (re.opt (re.+ (re.union (re.range "a" "z") (re.union (re.range "A" "Z") (re.union (re.range "0" "9") (str.to_re "_"))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)