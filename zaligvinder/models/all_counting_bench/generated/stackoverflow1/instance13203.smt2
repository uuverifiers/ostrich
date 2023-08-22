;test regex .{1,30}?keyword.{1,30}
(declare-const X String)
(assert (str.in_re X (re.++ ((_ re.loop 1 30) (re.diff re.allchar (str.to_re "\n"))) (re.++ (str.to_re "k") (re.++ (str.to_re "e") (re.++ (str.to_re "y") (re.++ (str.to_re "w") (re.++ (str.to_re "o") (re.++ (str.to_re "r") (re.++ (str.to_re "d") ((_ re.loop 1 30) (re.diff re.allchar (str.to_re "\n")))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)