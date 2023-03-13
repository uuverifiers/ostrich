;test regex ([a-z]:)?(\\\w+)+(\\|\.\w{3,4})?
(declare-const X String)
(assert (str.in_re X (re.++ (re.opt (re.++ (re.range "a" "z") (str.to_re ":"))) (re.++ (re.+ (re.++ (str.to_re "\\") (re.+ (re.union (re.range "a" "z") (re.union (re.range "A" "Z") (re.union (re.range "0" "9") (str.to_re "_"))))))) (re.opt (re.union (str.to_re "\\") (re.++ (str.to_re ".") ((_ re.loop 3 4) (re.union (re.range "a" "z") (re.union (re.range "A" "Z") (re.union (re.range "0" "9") (str.to_re "_"))))))))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)