;test regex ([A-Z0-9 ]{3,3}): ([0-9SW]+ )?([0-9\.SW]{3,})\n
(declare-const X String)
(assert (str.in_re X (re.++ ((_ re.loop 3 3) (re.union (re.range "A" "Z") (re.union (re.range "0" "9") (str.to_re " ")))) (re.++ (str.to_re ":") (re.++ (str.to_re " ") (re.++ (re.opt (re.++ (re.+ (re.union (re.range "0" "9") (re.union (str.to_re "S") (str.to_re "W")))) (str.to_re " "))) (re.++ (re.++ (re.* (re.union (re.range "0" "9") (re.union (str.to_re ".") (re.union (str.to_re "S") (str.to_re "W"))))) ((_ re.loop 3 3) (re.union (re.range "0" "9") (re.union (str.to_re ".") (re.union (str.to_re "S") (str.to_re "W")))))) (str.to_re "\u{0a}"))))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)