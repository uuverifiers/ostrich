;test regex '/links/51f5382e7b7993e335000015'.match(/^\/links\/([0-9a-f]{24})$/)
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "\u{27}") (re.++ (str.to_re "/") (re.++ (str.to_re "l") (re.++ (str.to_re "i") (re.++ (str.to_re "n") (re.++ (str.to_re "k") (re.++ (str.to_re "s") (re.++ (str.to_re "/") (re.++ (str.to_re "51") (re.++ (str.to_re "f") (re.++ (str.to_re "5382") (re.++ (str.to_re "e") (re.++ (str.to_re "7") (re.++ (str.to_re "b") (re.++ (str.to_re "7993") (re.++ (str.to_re "e") (re.++ (str.to_re "335000015") (re.++ (str.to_re "\u{27}") (re.++ (re.diff re.allchar (str.to_re "\n")) (re.++ (str.to_re "m") (re.++ (str.to_re "a") (re.++ (str.to_re "t") (re.++ (str.to_re "c") (re.++ (str.to_re "h") (re.++ (re.++ (str.to_re "/") (re.++ (str.to_re "") (re.++ (str.to_re "/") (re.++ (str.to_re "l") (re.++ (str.to_re "i") (re.++ (str.to_re "n") (re.++ (str.to_re "k") (re.++ (str.to_re "s") (re.++ (str.to_re "/") ((_ re.loop 24 24) (re.union (re.range "0" "9") (re.range "a" "f")))))))))))) (re.++ (str.to_re "") (str.to_re "/")))))))))))))))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)