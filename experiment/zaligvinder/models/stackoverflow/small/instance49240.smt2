;test regex sep = ([0369]|([258][0369]*[147])|([147]|[258]{2})([0369]|([147][0369]*[258]))*([258]|[147]{2}))+
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "s") (re.++ (str.to_re "e") (re.++ (str.to_re "p") (re.++ (str.to_re " ") (re.++ (str.to_re "=") (re.++ (str.to_re " ") (re.+ (re.union (re.union (str.to_re "0369") (re.++ (str.to_re "258") (re.++ (re.* (str.to_re "0369")) (str.to_re "147")))) (re.++ (re.union (str.to_re "147") ((_ re.loop 2 2) (str.to_re "258"))) (re.++ (re.* (re.union (str.to_re "0369") (re.++ (str.to_re "147") (re.++ (re.* (str.to_re "0369")) (str.to_re "258"))))) (re.union (str.to_re "258") ((_ re.loop 2 2) (str.to_re "147")))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)