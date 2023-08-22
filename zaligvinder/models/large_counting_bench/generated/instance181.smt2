;test regex context:(.+?){15000,}2017-0\d-\d\dT\d\d:\d\d:\d\d:
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "c") (re.++ (str.to_re "o") (re.++ (str.to_re "n") (re.++ (str.to_re "t") (re.++ (str.to_re "e") (re.++ (str.to_re "x") (re.++ (str.to_re "t") (re.++ (str.to_re ":") (re.++ (re.++ (re.* (re.+ (re.diff re.allchar (str.to_re "\n")))) ((_ re.loop 15000 15000) (re.+ (re.diff re.allchar (str.to_re "\n"))))) (re.++ (str.to_re "2017") (re.++ (str.to_re "-") (re.++ (str.to_re "0") (re.++ (re.range "0" "9") (re.++ (str.to_re "-") (re.++ (re.range "0" "9") (re.++ (re.range "0" "9") (re.++ (str.to_re "T") (re.++ (re.range "0" "9") (re.++ (re.range "0" "9") (re.++ (str.to_re ":") (re.++ (re.range "0" "9") (re.++ (re.range "0" "9") (re.++ (str.to_re ":") (re.++ (re.range "0" "9") (re.++ (re.range "0" "9") (str.to_re ":"))))))))))))))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 200 (str.len X)))
(check-sat)
(get-model)