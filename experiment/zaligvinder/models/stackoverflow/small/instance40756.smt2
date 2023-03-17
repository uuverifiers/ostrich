;test regex ^(.*?succeeded\..*?\d{4}.)|WARNING:.*?\.
(declare-const X String)
(assert (str.in_re X (re.union (re.++ (str.to_re "") (re.++ (re.* (re.diff re.allchar (str.to_re "\n"))) (re.++ (str.to_re "s") (re.++ (str.to_re "u") (re.++ (str.to_re "c") (re.++ (str.to_re "c") (re.++ (str.to_re "e") (re.++ (str.to_re "e") (re.++ (str.to_re "d") (re.++ (str.to_re "e") (re.++ (str.to_re "d") (re.++ (str.to_re ".") (re.++ (re.* (re.diff re.allchar (str.to_re "\n"))) (re.++ ((_ re.loop 4 4) (re.range "0" "9")) (re.diff re.allchar (str.to_re "\n")))))))))))))))) (re.++ (str.to_re "W") (re.++ (str.to_re "A") (re.++ (str.to_re "R") (re.++ (str.to_re "N") (re.++ (str.to_re "I") (re.++ (str.to_re "N") (re.++ (str.to_re "G") (re.++ (str.to_re ":") (re.++ (re.* (re.diff re.allchar (str.to_re "\n"))) (str.to_re ".")))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)