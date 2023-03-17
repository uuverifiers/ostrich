;test regex "^\\s*((100(\\.0*)?|\\d{1,2}(\\.\\d*)?|\\.\\d+)%?|PASSED|FAILED)\\s*$"
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "\u{22}") (re.++ (str.to_re "") (re.++ (str.to_re "\\") (re.++ (re.* (str.to_re "s")) (re.++ (re.union (re.union (re.++ (re.union (re.union (re.++ (str.to_re "100") (re.opt (re.++ (str.to_re "\\") (re.++ (re.diff re.allchar (str.to_re "\n")) (re.* (str.to_re "0")))))) (re.++ (str.to_re "\\") (re.++ ((_ re.loop 1 2) (str.to_re "d")) (re.opt (re.++ (str.to_re "\\") (re.++ (re.diff re.allchar (str.to_re "\n")) (re.++ (str.to_re "\\") (re.* (str.to_re "d"))))))))) (re.++ (str.to_re "\\") (re.++ (re.diff re.allchar (str.to_re "\n")) (re.++ (str.to_re "\\") (re.+ (str.to_re "d")))))) (re.opt (str.to_re "%"))) (re.++ (str.to_re "P") (re.++ (str.to_re "A") (re.++ (str.to_re "S") (re.++ (str.to_re "S") (re.++ (str.to_re "E") (str.to_re "D"))))))) (re.++ (str.to_re "F") (re.++ (str.to_re "A") (re.++ (str.to_re "I") (re.++ (str.to_re "L") (re.++ (str.to_re "E") (str.to_re "D"))))))) (re.++ (str.to_re "\\") (re.* (str.to_re "s")))))))) (re.++ (str.to_re "") (str.to_re "\u{22}")))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)