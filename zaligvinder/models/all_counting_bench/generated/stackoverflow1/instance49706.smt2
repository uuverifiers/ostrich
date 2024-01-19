;test regex (\\w+)((\\.|\\s)[sS]([0-9]{2})[eE]([0-9]{2}))
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "\\") (re.+ (str.to_re "w"))) (re.++ (re.union (re.++ (str.to_re "\\") (re.diff re.allchar (str.to_re "\n"))) (re.++ (str.to_re "\\") (str.to_re "s"))) (re.++ (re.union (str.to_re "s") (str.to_re "S")) (re.++ ((_ re.loop 2 2) (re.range "0" "9")) (re.++ (re.union (str.to_re "e") (str.to_re "E")) ((_ re.loop 2 2) (re.range "0" "9")))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)