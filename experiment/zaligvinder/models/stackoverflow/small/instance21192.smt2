;test regex ^\$\d{1,3}\.\d{1,2}\h*\R\K(?:^[^$].+\R)+
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "") (re.++ (str.to_re "$") (re.++ ((_ re.loop 1 3) (re.range "0" "9")) (re.++ (str.to_re ".") (re.++ ((_ re.loop 1 2) (re.range "0" "9")) (re.++ (re.* (str.to_re "h")) (re.++ (str.to_re "R") (re.++ (str.to_re "K") (re.+ (re.++ (str.to_re "") (re.++ (re.diff re.allchar (str.to_re "$")) (re.++ (re.+ (re.diff re.allchar (str.to_re "\n"))) (str.to_re "R")))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)