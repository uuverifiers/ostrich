;test regex $x =~ s/^(.*?SQL_log.*?SIZE = )\d+/${1}1024/;
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (re.++ (str.to_re "") (re.++ (str.to_re "x") (re.++ (str.to_re " ") (re.++ (str.to_re "=") (re.++ (str.to_re "~") (re.++ (str.to_re " ") (re.++ (str.to_re "s") (str.to_re "/")))))))) (re.++ (str.to_re "") (re.++ (re.++ (re.* (re.diff re.allchar (str.to_re "\n"))) (re.++ (str.to_re "S") (re.++ (str.to_re "Q") (re.++ (str.to_re "L") (re.++ (str.to_re "_") (re.++ (str.to_re "l") (re.++ (str.to_re "o") (re.++ (str.to_re "g") (re.++ (re.* (re.diff re.allchar (str.to_re "\n"))) (re.++ (str.to_re "S") (re.++ (str.to_re "I") (re.++ (str.to_re "Z") (re.++ (str.to_re "E") (re.++ (str.to_re " ") (re.++ (str.to_re "=") (str.to_re " ")))))))))))))))) (re.++ (re.+ (re.range "0" "9")) (str.to_re "/"))))) (re.++ ((_ re.loop 1 1) (str.to_re "")) (re.++ (str.to_re "1024") (re.++ (str.to_re "/") (str.to_re ";")))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)