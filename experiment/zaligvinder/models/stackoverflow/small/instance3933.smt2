;test regex .*ab4([a-zA-Z0-9 ()-.]{4}){1,4}\\r\\n.*
(declare-const X String)
(assert (str.in_re X (re.++ (re.* (re.diff re.allchar (str.to_re "\n"))) (re.++ (str.to_re "a") (re.++ (str.to_re "b") (re.++ (str.to_re "4") (re.++ ((_ re.loop 1 4) ((_ re.loop 4 4) (re.union (re.range "a" "z") (re.union (re.range "A" "Z") (re.union (re.range "0" "9") (re.union (str.to_re " ") (re.union (str.to_re "(") (re.union (str.to_re ")") (re.union (str.to_re "-") (str.to_re ".")))))))))) (re.++ (str.to_re "\\") (re.++ (str.to_re "r") (re.++ (str.to_re "\\") (re.++ (str.to_re "n") (re.* (re.diff re.allchar (str.to_re "\n"))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)