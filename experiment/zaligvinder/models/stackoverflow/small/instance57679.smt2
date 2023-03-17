;test regex length($_) == 12 && /^(?:\D*\d){7}/ && /^(?:\PL*\pL){5}/
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (re.++ (str.to_re "l") (re.++ (str.to_re "e") (re.++ (str.to_re "n") (re.++ (str.to_re "g") (re.++ (str.to_re "t") (re.++ (str.to_re "h") (re.++ (re.++ (str.to_re "") (str.to_re "_")) (re.++ (str.to_re " ") (re.++ (str.to_re "=") (re.++ (str.to_re "=") (re.++ (str.to_re " ") (re.++ (str.to_re "12") (re.++ (str.to_re " ") (re.++ (str.to_re "&") (re.++ (str.to_re "&") (re.++ (str.to_re " ") (str.to_re "/"))))))))))))))))) (re.++ (str.to_re "") (re.++ ((_ re.loop 7 7) (re.++ (re.* (re.diff re.allchar (re.range "0" "9"))) (re.range "0" "9"))) (re.++ (str.to_re "/") (re.++ (str.to_re " ") (re.++ (str.to_re "&") (re.++ (str.to_re "&") (re.++ (str.to_re " ") (str.to_re "/"))))))))) (re.++ (str.to_re "") (re.++ ((_ re.loop 5 5) (re.++ (str.to_re "P") (re.++ (re.* (str.to_re "L")) (re.++ (str.to_re "p") (str.to_re "L"))))) (str.to_re "/"))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)