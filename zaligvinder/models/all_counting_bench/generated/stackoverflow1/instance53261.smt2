;test regex ~^.*(?:youtu\.be\/|youtube\.com\/(?:[^\?]*\?(?:.*&)?v=|(?:embed|v|user)\/))([^\?&"\'>]{11}).*$~si
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "~") (re.++ (str.to_re "") (re.++ (re.* (re.diff re.allchar (str.to_re "\n"))) (re.++ (re.union (re.++ (str.to_re "y") (re.++ (str.to_re "o") (re.++ (str.to_re "u") (re.++ (str.to_re "t") (re.++ (str.to_re "u") (re.++ (str.to_re ".") (re.++ (str.to_re "b") (re.++ (str.to_re "e") (str.to_re "/"))))))))) (re.++ (str.to_re "y") (re.++ (str.to_re "o") (re.++ (str.to_re "u") (re.++ (str.to_re "t") (re.++ (str.to_re "u") (re.++ (str.to_re "b") (re.++ (str.to_re "e") (re.++ (str.to_re ".") (re.++ (str.to_re "c") (re.++ (str.to_re "o") (re.++ (str.to_re "m") (re.++ (str.to_re "/") (re.union (re.++ (re.* (re.diff re.allchar (str.to_re "?"))) (re.++ (str.to_re "?") (re.++ (re.opt (re.++ (re.* (re.diff re.allchar (str.to_re "\n"))) (str.to_re "&"))) (re.++ (str.to_re "v") (str.to_re "="))))) (re.++ (re.union (re.union (re.++ (str.to_re "e") (re.++ (str.to_re "m") (re.++ (str.to_re "b") (re.++ (str.to_re "e") (str.to_re "d"))))) (str.to_re "v")) (re.++ (str.to_re "u") (re.++ (str.to_re "s") (re.++ (str.to_re "e") (str.to_re "r"))))) (str.to_re "/")))))))))))))))) (re.++ ((_ re.loop 11 11) (re.inter (re.diff re.allchar (str.to_re "?")) (re.inter (re.diff re.allchar (str.to_re "&")) (re.inter (re.diff re.allchar (str.to_re "\u{22}")) (re.inter (re.diff re.allchar (str.to_re "\u{27}")) (re.diff re.allchar (str.to_re ">"))))))) (re.* (re.diff re.allchar (str.to_re "\n")))))))) (re.++ (str.to_re "") (re.++ (str.to_re "~") (re.++ (str.to_re "s") (str.to_re "i")))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)