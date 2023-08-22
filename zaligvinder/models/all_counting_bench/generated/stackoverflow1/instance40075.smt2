;test regex ((R|[A-Z]{3}) ?([5-9]|[1-9][0-9]{1,2})((,| )?[0-9]{3}){2,})\.[0-9]{2}
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (re.union (str.to_re "R") ((_ re.loop 3 3) (re.range "A" "Z"))) (re.++ (re.opt (str.to_re " ")) (re.++ (re.union (re.range "5" "9") (re.++ (re.range "1" "9") ((_ re.loop 1 2) (re.range "0" "9")))) (re.++ (re.* (re.++ (re.opt (re.union (str.to_re ",") (str.to_re " "))) ((_ re.loop 3 3) (re.range "0" "9")))) ((_ re.loop 2 2) (re.++ (re.opt (re.union (str.to_re ",") (str.to_re " "))) ((_ re.loop 3 3) (re.range "0" "9")))))))) (re.++ (str.to_re ".") ((_ re.loop 2 2) (re.range "0" "9"))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)