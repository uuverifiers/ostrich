;test regex SELECT 'a abcdef' REGEXP '^[a-zA-Z]{6,}$'
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (re.++ (str.to_re "S") (re.++ (str.to_re "E") (re.++ (str.to_re "L") (re.++ (str.to_re "E") (re.++ (str.to_re "C") (re.++ (str.to_re "T") (re.++ (str.to_re " ") (re.++ (str.to_re "\u{27}") (re.++ (str.to_re "a") (re.++ (str.to_re " ") (re.++ (str.to_re "a") (re.++ (str.to_re "b") (re.++ (str.to_re "c") (re.++ (str.to_re "d") (re.++ (str.to_re "e") (re.++ (str.to_re "f") (re.++ (str.to_re "\u{27}") (re.++ (str.to_re " ") (re.++ (str.to_re "R") (re.++ (str.to_re "E") (re.++ (str.to_re "G") (re.++ (str.to_re "E") (re.++ (str.to_re "X") (re.++ (str.to_re "P") (re.++ (str.to_re " ") (str.to_re "\u{27}")))))))))))))))))))))))))) (re.++ (str.to_re "") (re.++ (re.* (re.union (re.range "a" "z") (re.range "A" "Z"))) ((_ re.loop 6 6) (re.union (re.range "a" "z") (re.range "A" "Z")))))) (re.++ (str.to_re "") (str.to_re "\u{27}")))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)