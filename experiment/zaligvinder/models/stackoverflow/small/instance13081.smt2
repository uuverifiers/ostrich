;test regex (?:GeraLinha\(.*\r?\n){5}(GeraLinha\(.*)
(declare-const X String)
(assert (str.in_re X (re.++ ((_ re.loop 5 5) (re.++ (str.to_re "G") (re.++ (str.to_re "e") (re.++ (str.to_re "r") (re.++ (str.to_re "a") (re.++ (str.to_re "L") (re.++ (str.to_re "i") (re.++ (str.to_re "n") (re.++ (str.to_re "h") (re.++ (str.to_re "a") (re.++ (str.to_re "(") (re.++ (re.* (re.diff re.allchar (str.to_re "\n"))) (re.++ (re.opt (str.to_re "\u{0d}")) (str.to_re "\u{0a}")))))))))))))) (re.++ (str.to_re "G") (re.++ (str.to_re "e") (re.++ (str.to_re "r") (re.++ (str.to_re "a") (re.++ (str.to_re "L") (re.++ (str.to_re "i") (re.++ (str.to_re "n") (re.++ (str.to_re "h") (re.++ (str.to_re "a") (re.++ (str.to_re "(") (re.* (re.diff re.allchar (str.to_re "\n"))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)