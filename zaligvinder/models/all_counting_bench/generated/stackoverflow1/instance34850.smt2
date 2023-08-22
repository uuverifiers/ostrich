;test regex ^[a-zA-Z]+(_([a-z]{2}(_[A-Z]{0,2})?|[a-z]{0,2}(_[A-Z]{2})?){1}(_\\w*)?){1}\\.properties$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ (re.+ (re.union (re.range "a" "z") (re.range "A" "Z"))) (re.++ ((_ re.loop 1 1) (re.++ (str.to_re "_") (re.++ ((_ re.loop 1 1) (re.union (re.++ ((_ re.loop 2 2) (re.range "a" "z")) (re.opt (re.++ (str.to_re "_") ((_ re.loop 0 2) (re.range "A" "Z"))))) (re.++ ((_ re.loop 0 2) (re.range "a" "z")) (re.opt (re.++ (str.to_re "_") ((_ re.loop 2 2) (re.range "A" "Z"))))))) (re.opt (re.++ (str.to_re "_") (re.++ (str.to_re "\\") (re.* (str.to_re "w")))))))) (re.++ (str.to_re "\\") (re.++ (re.diff re.allchar (str.to_re "\n")) (re.++ (str.to_re "p") (re.++ (str.to_re "r") (re.++ (str.to_re "o") (re.++ (str.to_re "p") (re.++ (str.to_re "e") (re.++ (str.to_re "r") (re.++ (str.to_re "t") (re.++ (str.to_re "i") (re.++ (str.to_re "e") (str.to_re "s"))))))))))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)