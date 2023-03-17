;test regex ^([a-z0-9]+p.{1}|[a-su-z0-9]+p)t
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "") (re.++ (re.union (re.++ (re.+ (re.union (re.range "a" "z") (re.range "0" "9"))) (re.++ (str.to_re "p") ((_ re.loop 1 1) (re.diff re.allchar (str.to_re "\n"))))) (re.++ (re.+ (re.union (re.range "a" "s") (re.union (re.range "u" "z") (re.range "0" "9")))) (str.to_re "p"))) (str.to_re "t")))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)