;test regex ([^\+\-]*(?:0|0\*|\*0){1,}[^\+\-]*)|(?:1\*|\*1)
(declare-const X String)
(assert (str.in_re X (re.union (re.++ (re.* (re.inter (re.diff re.allchar (str.to_re "+")) (re.diff re.allchar (str.to_re "-")))) (re.++ (re.++ (re.* (re.union (re.union (str.to_re "0") (re.++ (str.to_re "0") (str.to_re "*"))) (re.++ (str.to_re "*") (str.to_re "0")))) ((_ re.loop 1 1) (re.union (re.union (str.to_re "0") (re.++ (str.to_re "0") (str.to_re "*"))) (re.++ (str.to_re "*") (str.to_re "0"))))) (re.* (re.inter (re.diff re.allchar (str.to_re "+")) (re.diff re.allchar (str.to_re "-")))))) (re.union (re.++ (str.to_re "1") (str.to_re "*")) (re.++ (str.to_re "*") (str.to_re "1"))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)