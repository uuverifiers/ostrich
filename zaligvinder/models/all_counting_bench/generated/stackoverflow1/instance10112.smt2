;test regex .{4}(?:0*([1-9]{1,10}|\w{10}))$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ ((_ re.loop 4 4) (re.diff re.allchar (str.to_re "\n"))) (re.++ (re.* (str.to_re "0")) (re.union ((_ re.loop 1 10) (re.range "1" "9")) ((_ re.loop 10 10) (re.union (re.range "a" "z") (re.union (re.range "A" "Z") (re.union (re.range "0" "9") (str.to_re "_")))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)