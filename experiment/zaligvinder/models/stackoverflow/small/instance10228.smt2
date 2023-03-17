;test regex DATE: (\d+)Key Type: (.*?) Key: ((?:\w{5}-){5}\w{5})
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "D") (re.++ (str.to_re "A") (re.++ (str.to_re "T") (re.++ (str.to_re "E") (re.++ (str.to_re ":") (re.++ (str.to_re " ") (re.++ (re.+ (re.range "0" "9")) (re.++ (str.to_re "K") (re.++ (str.to_re "e") (re.++ (str.to_re "y") (re.++ (str.to_re " ") (re.++ (str.to_re "T") (re.++ (str.to_re "y") (re.++ (str.to_re "p") (re.++ (str.to_re "e") (re.++ (str.to_re ":") (re.++ (str.to_re " ") (re.++ (re.* (re.diff re.allchar (str.to_re "\n"))) (re.++ (str.to_re " ") (re.++ (str.to_re "K") (re.++ (str.to_re "e") (re.++ (str.to_re "y") (re.++ (str.to_re ":") (re.++ (str.to_re " ") (re.++ ((_ re.loop 5 5) (re.++ ((_ re.loop 5 5) (re.union (re.range "a" "z") (re.union (re.range "A" "Z") (re.union (re.range "0" "9") (str.to_re "_"))))) (str.to_re "-"))) ((_ re.loop 5 5) (re.union (re.range "a" "z") (re.union (re.range "A" "Z") (re.union (re.range "0" "9") (str.to_re "_"))))))))))))))))))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)