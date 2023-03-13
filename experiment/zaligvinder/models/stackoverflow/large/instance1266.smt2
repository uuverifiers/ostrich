;test regex ([A-z *-]{2,50}[A-z]{2,50})(.{0,3}([0-9-]{0,3}[A-z *+.#-/]{0,3}){1,10})
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ ((_ re.loop 2 50) (re.union (re.range "A" "z") (re.union (str.to_re " ") (re.union (str.to_re "*") (str.to_re "-"))))) ((_ re.loop 2 50) (re.range "A" "z"))) (re.++ ((_ re.loop 0 3) (re.diff re.allchar (str.to_re "\n"))) ((_ re.loop 1 10) (re.++ ((_ re.loop 0 3) (re.union (re.range "0" "9") (str.to_re "-"))) ((_ re.loop 0 3) (re.union (re.range "A" "z") (re.union (str.to_re " ") (re.union (str.to_re "*") (re.union (str.to_re "+") (re.union (str.to_re ".") (re.range "#" "/")))))))))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 50 (str.len X)))
(check-sat)
(get-model)