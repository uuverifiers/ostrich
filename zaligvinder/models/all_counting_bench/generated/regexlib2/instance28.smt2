;test regex ^http[s]?://([a-zA-Z0-9\-]+\.)*([a-zA-Z]{3,61}|[a-zA-Z]{1,}\.[a-zA-Z]{2})/.*$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ (str.to_re "h") (re.++ (str.to_re "t") (re.++ (str.to_re "t") (re.++ (str.to_re "p") (re.++ (re.opt (str.to_re "s")) (re.++ (str.to_re ":") (re.++ (str.to_re "/") (re.++ (str.to_re "/") (re.++ (re.* (re.++ (re.+ (re.union (re.range "a" "z") (re.union (re.range "A" "Z") (re.union (re.range "0" "9") (str.to_re "-"))))) (str.to_re "."))) (re.++ (re.union ((_ re.loop 3 61) (re.union (re.range "a" "z") (re.range "A" "Z"))) (re.++ (re.++ (re.* (re.union (re.range "a" "z") (re.range "A" "Z"))) ((_ re.loop 1 1) (re.union (re.range "a" "z") (re.range "A" "Z")))) (re.++ (str.to_re ".") ((_ re.loop 2 2) (re.union (re.range "a" "z") (re.range "A" "Z")))))) (re.++ (str.to_re "/") (re.* (re.diff re.allchar (str.to_re "\n"))))))))))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)