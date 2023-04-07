;test regex .replace(/(?:(<li>(.*?)<\/li>){28})/g,'<ul>$1</ul>')
(declare-const X String)
(assert (str.in_re X (re.++ (re.diff re.allchar (str.to_re "\n")) (re.++ (str.to_re "r") (re.++ (str.to_re "e") (re.++ (str.to_re "p") (re.++ (str.to_re "l") (re.++ (str.to_re "a") (re.++ (str.to_re "c") (re.++ (str.to_re "e") (re.++ (re.++ (re.++ (str.to_re "/") (re.++ ((_ re.loop 28 28) (re.++ (str.to_re "<") (re.++ (str.to_re "l") (re.++ (str.to_re "i") (re.++ (str.to_re ">") (re.++ (re.* (re.diff re.allchar (str.to_re "\n"))) (re.++ (str.to_re "<") (re.++ (str.to_re "/") (re.++ (str.to_re "l") (re.++ (str.to_re "i") (str.to_re ">"))))))))))) (re.++ (str.to_re "/") (str.to_re "g")))) (re.++ (str.to_re ",") (re.++ (str.to_re "\u{27}") (re.++ (str.to_re "<") (re.++ (str.to_re "u") (re.++ (str.to_re "l") (str.to_re ">"))))))) (re.++ (str.to_re "") (re.++ (str.to_re "1") (re.++ (str.to_re "<") (re.++ (str.to_re "/") (re.++ (str.to_re "u") (re.++ (str.to_re "l") (re.++ (str.to_re ">") (str.to_re "\u{27}")))))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)