;test regex <phoneMobile>(8|\+7)9[0-9]{2}[0-9]{7}</phoneMobile>
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "<") (re.++ (str.to_re "p") (re.++ (str.to_re "h") (re.++ (str.to_re "o") (re.++ (str.to_re "n") (re.++ (str.to_re "e") (re.++ (str.to_re "M") (re.++ (str.to_re "o") (re.++ (str.to_re "b") (re.++ (str.to_re "i") (re.++ (str.to_re "l") (re.++ (str.to_re "e") (re.++ (str.to_re ">") (re.++ (re.union (str.to_re "8") (re.++ (str.to_re "+") (str.to_re "7"))) (re.++ (str.to_re "9") (re.++ ((_ re.loop 2 2) (re.range "0" "9")) (re.++ ((_ re.loop 7 7) (re.range "0" "9")) (re.++ (str.to_re "<") (re.++ (str.to_re "/") (re.++ (str.to_re "p") (re.++ (str.to_re "h") (re.++ (str.to_re "o") (re.++ (str.to_re "n") (re.++ (str.to_re "e") (re.++ (str.to_re "M") (re.++ (str.to_re "o") (re.++ (str.to_re "b") (re.++ (str.to_re "i") (re.++ (str.to_re "l") (re.++ (str.to_re "e") (str.to_re ">")))))))))))))))))))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)