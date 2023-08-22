;test regex PP_INFO #[ ][0-9]+[ ]\"[^"]*\"[ ][1-4]{0,4}
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "P") (re.++ (str.to_re "P") (re.++ (str.to_re "_") (re.++ (str.to_re "I") (re.++ (str.to_re "N") (re.++ (str.to_re "F") (re.++ (str.to_re "O") (re.++ (str.to_re " ") (re.++ (str.to_re "#") (re.++ (str.to_re " ") (re.++ (re.+ (re.range "0" "9")) (re.++ (str.to_re " ") (re.++ (str.to_re "\u{22}") (re.++ (re.* (re.diff re.allchar (str.to_re "\u{22}"))) (re.++ (str.to_re "\u{22}") (re.++ (str.to_re " ") ((_ re.loop 0 4) (re.range "1" "4"))))))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)