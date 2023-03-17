;test regex (?:a|b)(?:1|1000)[cd]{3}(.)(?:a|b)[cd]{3}
(declare-const X String)
(assert (str.in_re X (re.++ (re.union (str.to_re "a") (str.to_re "b")) (re.++ (re.union (str.to_re "1") (str.to_re "1000")) (re.++ ((_ re.loop 3 3) (re.union (str.to_re "c") (str.to_re "d"))) (re.++ (re.diff re.allchar (str.to_re "\n")) (re.++ (re.union (str.to_re "a") (str.to_re "b")) ((_ re.loop 3 3) (re.union (str.to_re "c") (str.to_re "d"))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)