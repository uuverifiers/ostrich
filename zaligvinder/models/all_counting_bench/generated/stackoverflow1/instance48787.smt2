;test regex "^(([\\w+/]{4}){19}\r\n)*(([\\w+/]{4})*([\\w+/]{4}|[\\w+/]{3}=|[\\w+/]{2}==))$"
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "\u{22}") (re.++ (str.to_re "") (re.++ (re.* (re.++ ((_ re.loop 19 19) ((_ re.loop 4 4) (re.union (str.to_re "\\") (re.union (str.to_re "w") (re.union (str.to_re "+") (str.to_re "/")))))) (re.++ (str.to_re "\u{0d}") (str.to_re "\u{0a}")))) (re.++ (re.* ((_ re.loop 4 4) (re.union (str.to_re "\\") (re.union (str.to_re "w") (re.union (str.to_re "+") (str.to_re "/")))))) (re.union (re.union ((_ re.loop 4 4) (re.union (str.to_re "\\") (re.union (str.to_re "w") (re.union (str.to_re "+") (str.to_re "/"))))) (re.++ ((_ re.loop 3 3) (re.union (str.to_re "\\") (re.union (str.to_re "w") (re.union (str.to_re "+") (str.to_re "/"))))) (str.to_re "="))) (re.++ ((_ re.loop 2 2) (re.union (str.to_re "\\") (re.union (str.to_re "w") (re.union (str.to_re "+") (str.to_re "/"))))) (re.++ (str.to_re "=") (str.to_re "=")))))))) (re.++ (str.to_re "") (str.to_re "\u{22}")))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)