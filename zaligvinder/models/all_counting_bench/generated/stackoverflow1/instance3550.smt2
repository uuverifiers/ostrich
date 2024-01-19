;test regex (MATERIALS)(,.*?){4}(,\d+?),
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (re.++ (str.to_re "M") (re.++ (str.to_re "A") (re.++ (str.to_re "T") (re.++ (str.to_re "E") (re.++ (str.to_re "R") (re.++ (str.to_re "I") (re.++ (str.to_re "A") (re.++ (str.to_re "L") (str.to_re "S"))))))))) (re.++ ((_ re.loop 4 4) (re.++ (str.to_re ",") (re.* (re.diff re.allchar (str.to_re "\n"))))) (re.++ (str.to_re ",") (re.+ (re.range "0" "9"))))) (str.to_re ","))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)