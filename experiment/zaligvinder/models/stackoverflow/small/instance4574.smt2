;test regex \d{1,4}( \w+){1,5}, (.*), ( \w+){1,5}, (AZ|CA|CO|NH), [0-9]{5}(-[0-9]{4})?
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (re.++ (re.++ (re.++ ((_ re.loop 1 4) (re.range "0" "9")) ((_ re.loop 1 5) (re.++ (str.to_re " ") (re.+ (re.union (re.range "a" "z") (re.union (re.range "A" "Z") (re.union (re.range "0" "9") (str.to_re "_")))))))) (re.++ (str.to_re ",") (re.++ (str.to_re " ") (re.* (re.diff re.allchar (str.to_re "\n")))))) (re.++ (str.to_re ",") (re.++ (str.to_re " ") ((_ re.loop 1 5) (re.++ (str.to_re " ") (re.+ (re.union (re.range "a" "z") (re.union (re.range "A" "Z") (re.union (re.range "0" "9") (str.to_re "_")))))))))) (re.++ (str.to_re ",") (re.++ (str.to_re " ") (re.union (re.union (re.union (re.++ (str.to_re "A") (str.to_re "Z")) (re.++ (str.to_re "C") (str.to_re "A"))) (re.++ (str.to_re "C") (str.to_re "O"))) (re.++ (str.to_re "N") (str.to_re "H")))))) (re.++ (str.to_re ",") (re.++ (str.to_re " ") (re.++ ((_ re.loop 5 5) (re.range "0" "9")) (re.opt (re.++ (str.to_re "-") ((_ re.loop 4 4) (re.range "0" "9"))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)