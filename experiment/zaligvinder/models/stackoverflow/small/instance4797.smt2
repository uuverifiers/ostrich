;test regex gsub("(^N{1,}|N{1,}$)","",x)
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "g") (re.++ (str.to_re "s") (re.++ (str.to_re "u") (re.++ (str.to_re "b") (re.++ (re.++ (re.++ (str.to_re "\u{22}") (re.++ (re.union (re.++ (str.to_re "") (re.++ (re.* (str.to_re "N")) ((_ re.loop 1 1) (str.to_re "N")))) (re.++ (re.++ (re.* (str.to_re "N")) ((_ re.loop 1 1) (str.to_re "N"))) (str.to_re ""))) (str.to_re "\u{22}"))) (re.++ (str.to_re ",") (re.++ (str.to_re "\u{22}") (str.to_re "\u{22}")))) (re.++ (str.to_re ",") (str.to_re "x")))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)