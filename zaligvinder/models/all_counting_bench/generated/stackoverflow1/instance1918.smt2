;test regex =REGEXREPLACE(E2;"([A-z0-9._%+-]+@[A-z0-9.-]+\.[A-z]{2,4})";"$1")
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "=") (re.++ (str.to_re "R") (re.++ (str.to_re "E") (re.++ (str.to_re "G") (re.++ (str.to_re "E") (re.++ (str.to_re "X") (re.++ (str.to_re "R") (re.++ (str.to_re "E") (re.++ (str.to_re "P") (re.++ (str.to_re "L") (re.++ (str.to_re "A") (re.++ (str.to_re "C") (re.++ (str.to_re "E") (re.++ (re.++ (str.to_re "E") (re.++ (str.to_re "2") (re.++ (str.to_re ";") (re.++ (str.to_re "\u{22}") (re.++ (re.++ (re.+ (re.union (re.range "A" "z") (re.union (re.range "0" "9") (re.union (str.to_re ".") (re.union (str.to_re "_") (re.union (str.to_re "%") (re.union (str.to_re "+") (str.to_re "-")))))))) (re.++ (str.to_re "@") (re.++ (re.+ (re.union (re.range "A" "z") (re.union (re.range "0" "9") (re.union (str.to_re ".") (str.to_re "-"))))) (re.++ (str.to_re ".") ((_ re.loop 2 4) (re.range "A" "z")))))) (re.++ (str.to_re "\u{22}") (re.++ (str.to_re ";") (str.to_re "\u{22}")))))))) (re.++ (str.to_re "") (re.++ (str.to_re "1") (str.to_re "\u{22}")))))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)