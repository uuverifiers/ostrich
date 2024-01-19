;test regex $str =~ s/(.)\g{1}+/ $1. ( $+[0] - $-[0] ) /ge;
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ (str.to_re "s") (re.++ (str.to_re "t") (re.++ (str.to_re "r") (re.++ (str.to_re " ") (re.++ (str.to_re "=") (re.++ (str.to_re "~") (re.++ (str.to_re " ") (re.++ (str.to_re "s") (re.++ (str.to_re "/") (re.++ (re.diff re.allchar (str.to_re "\n")) (re.++ (re.+ ((_ re.loop 1 1) (str.to_re "g"))) (re.++ (str.to_re "/") (str.to_re " ")))))))))))))) (re.++ (str.to_re "") (re.++ (str.to_re "1") (re.++ (re.diff re.allchar (str.to_re "\n")) (re.++ (str.to_re " ") (re.++ (re.++ (re.++ (str.to_re " ") (re.++ (re.+ (str.to_re "")) (re.++ (str.to_re "0") (re.++ (str.to_re " ") (re.++ (str.to_re "-") (str.to_re " ")))))) (re.++ (str.to_re "") (re.++ (str.to_re "-") (re.++ (str.to_re "0") (str.to_re " "))))) (re.++ (str.to_re " ") (re.++ (str.to_re "/") (re.++ (str.to_re "g") (re.++ (str.to_re "e") (str.to_re ";")))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)