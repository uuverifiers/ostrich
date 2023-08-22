;test regex ^.*([0-9]{5,}|[5-9][0-9]{3})(ms|cpu_ms|api_cpu_ms).*$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ (re.* (re.diff re.allchar (str.to_re "\n"))) (re.++ (re.union (re.++ (re.* (re.range "0" "9")) ((_ re.loop 5 5) (re.range "0" "9"))) (re.++ (re.range "5" "9") ((_ re.loop 3 3) (re.range "0" "9")))) (re.++ (re.union (re.union (re.++ (str.to_re "m") (str.to_re "s")) (re.++ (str.to_re "c") (re.++ (str.to_re "p") (re.++ (str.to_re "u") (re.++ (str.to_re "_") (re.++ (str.to_re "m") (str.to_re "s"))))))) (re.++ (str.to_re "a") (re.++ (str.to_re "p") (re.++ (str.to_re "i") (re.++ (str.to_re "_") (re.++ (str.to_re "c") (re.++ (str.to_re "p") (re.++ (str.to_re "u") (re.++ (str.to_re "_") (re.++ (str.to_re "m") (str.to_re "s"))))))))))) (re.* (re.diff re.allchar (str.to_re "\n"))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)