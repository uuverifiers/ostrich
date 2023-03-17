;test regex :32[^:]:.?([a-zA-Z]{6}\d[a-zA-Z]XXX)
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re ":") (re.++ (str.to_re "32") (re.++ (re.diff re.allchar (str.to_re ":")) (re.++ (str.to_re ":") (re.++ (re.opt (re.diff re.allchar (str.to_re "\n"))) (re.++ ((_ re.loop 6 6) (re.union (re.range "a" "z") (re.range "A" "Z"))) (re.++ (re.range "0" "9") (re.++ (re.union (re.range "a" "z") (re.range "A" "Z")) (re.++ (str.to_re "X") (re.++ (str.to_re "X") (str.to_re "X")))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)