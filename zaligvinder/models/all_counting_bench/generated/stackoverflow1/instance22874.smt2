;test regex "\\d{1,5}\\s(\\b\\w+\\b){1,2}\\w*\\s?,?\\w*\\s?,?\\w*\\s?,?[A-ZA-Z]"
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (re.++ (re.++ (str.to_re "\u{22}") (re.++ (str.to_re "\\") (re.++ ((_ re.loop 1 5) (str.to_re "d")) (re.++ (str.to_re "\\") (re.++ (str.to_re "s") (re.++ ((_ re.loop 1 2) (re.++ (str.to_re "\\") (re.++ (str.to_re "b") (re.++ (str.to_re "\\") (re.++ (re.+ (str.to_re "w")) (re.++ (str.to_re "\\") (str.to_re "b"))))))) (re.++ (str.to_re "\\") (re.++ (re.* (str.to_re "w")) (re.++ (str.to_re "\\") (re.opt (str.to_re "s"))))))))))) (re.++ (re.opt (str.to_re ",")) (re.++ (str.to_re "\\") (re.++ (re.* (str.to_re "w")) (re.++ (str.to_re "\\") (re.opt (str.to_re "s"))))))) (re.++ (re.opt (str.to_re ",")) (re.++ (str.to_re "\\") (re.++ (re.* (str.to_re "w")) (re.++ (str.to_re "\\") (re.opt (str.to_re "s"))))))) (re.++ (re.opt (str.to_re ",")) (re.++ (re.union (re.range "A" "Z") (re.range "A" "Z")) (str.to_re "\u{22}"))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)