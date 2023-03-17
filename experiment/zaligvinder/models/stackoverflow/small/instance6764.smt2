;test regex ^(?:xxSTART.*?xxEND){2}(xxSTART.*?xxEND)
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "") (re.++ ((_ re.loop 2 2) (re.++ (str.to_re "x") (re.++ (str.to_re "x") (re.++ (str.to_re "S") (re.++ (str.to_re "T") (re.++ (str.to_re "A") (re.++ (str.to_re "R") (re.++ (str.to_re "T") (re.++ (re.* (re.diff re.allchar (str.to_re "\n"))) (re.++ (str.to_re "x") (re.++ (str.to_re "x") (re.++ (str.to_re "E") (re.++ (str.to_re "N") (str.to_re "D")))))))))))))) (re.++ (str.to_re "x") (re.++ (str.to_re "x") (re.++ (str.to_re "S") (re.++ (str.to_re "T") (re.++ (str.to_re "A") (re.++ (str.to_re "R") (re.++ (str.to_re "T") (re.++ (re.* (re.diff re.allchar (str.to_re "\n"))) (re.++ (str.to_re "x") (re.++ (str.to_re "x") (re.++ (str.to_re "E") (re.++ (str.to_re "N") (str.to_re "D")))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)