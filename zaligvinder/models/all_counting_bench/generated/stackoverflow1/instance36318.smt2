;test regex IPV4="^(|[0-9]{1,3}.[0-9]{1,3}.[0-9]{1,3}.[0-9]{1,3})\|"
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "I") (re.++ (str.to_re "P") (re.++ (str.to_re "V") (re.++ (str.to_re "4") (re.++ (str.to_re "=") (str.to_re "\u{22}")))))) (re.++ (str.to_re "") (re.++ (re.union (str.to_re "") (re.++ (str.to_re "") (re.++ ((_ re.loop 1 3) (re.range "0" "9")) (re.++ (re.diff re.allchar (str.to_re "\n")) (re.++ ((_ re.loop 1 3) (re.range "0" "9")) (re.++ (re.diff re.allchar (str.to_re "\n")) (re.++ ((_ re.loop 1 3) (re.range "0" "9")) (re.++ (re.diff re.allchar (str.to_re "\n")) ((_ re.loop 1 3) (re.range "0" "9")))))))))) (re.++ (str.to_re "|") (str.to_re "\u{22}")))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)