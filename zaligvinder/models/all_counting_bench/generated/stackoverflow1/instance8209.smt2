;test regex str.match(/\d{1,2}.SSRDOCSYYHK1\/\/\/\/\/.+?\d\.\d/m)
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "s") (re.++ (str.to_re "t") (re.++ (str.to_re "r") (re.++ (re.diff re.allchar (str.to_re "\n")) (re.++ (str.to_re "m") (re.++ (str.to_re "a") (re.++ (str.to_re "t") (re.++ (str.to_re "c") (re.++ (str.to_re "h") (re.++ (str.to_re "/") (re.++ ((_ re.loop 1 2) (re.range "0" "9")) (re.++ (re.diff re.allchar (str.to_re "\n")) (re.++ (str.to_re "S") (re.++ (str.to_re "S") (re.++ (str.to_re "R") (re.++ (str.to_re "D") (re.++ (str.to_re "O") (re.++ (str.to_re "C") (re.++ (str.to_re "S") (re.++ (str.to_re "Y") (re.++ (str.to_re "Y") (re.++ (str.to_re "H") (re.++ (str.to_re "K") (re.++ (str.to_re "1") (re.++ (str.to_re "/") (re.++ (str.to_re "/") (re.++ (str.to_re "/") (re.++ (str.to_re "/") (re.++ (str.to_re "/") (re.++ (re.+ (re.diff re.allchar (str.to_re "\n"))) (re.++ (re.range "0" "9") (re.++ (str.to_re ".") (re.++ (re.range "0" "9") (re.++ (str.to_re "/") (str.to_re "m")))))))))))))))))))))))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)