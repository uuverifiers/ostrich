;test regex <input type="text" name="movie" maxlength="4" pattern="([01]?[0-9]|2[0-3])[0-5][0-9]" pattern=".{0}|.{4,4}" value='<?php echo $objResult["MOVIE"]; ?>'>
(declare-const X String)
(assert (str.in_re X (re.union (re.++ (str.to_re "<") (re.++ (str.to_re "i") (re.++ (str.to_re "n") (re.++ (str.to_re "p") (re.++ (str.to_re "u") (re.++ (str.to_re "t") (re.++ (str.to_re " ") (re.++ (str.to_re "t") (re.++ (str.to_re "y") (re.++ (str.to_re "p") (re.++ (str.to_re "e") (re.++ (str.to_re "=") (re.++ (str.to_re "\u{22}") (re.++ (str.to_re "t") (re.++ (str.to_re "e") (re.++ (str.to_re "x") (re.++ (str.to_re "t") (re.++ (str.to_re "\u{22}") (re.++ (str.to_re " ") (re.++ (str.to_re "n") (re.++ (str.to_re "a") (re.++ (str.to_re "m") (re.++ (str.to_re "e") (re.++ (str.to_re "=") (re.++ (str.to_re "\u{22}") (re.++ (str.to_re "m") (re.++ (str.to_re "o") (re.++ (str.to_re "v") (re.++ (str.to_re "i") (re.++ (str.to_re "e") (re.++ (str.to_re "\u{22}") (re.++ (str.to_re " ") (re.++ (str.to_re "m") (re.++ (str.to_re "a") (re.++ (str.to_re "x") (re.++ (str.to_re "l") (re.++ (str.to_re "e") (re.++ (str.to_re "n") (re.++ (str.to_re "g") (re.++ (str.to_re "t") (re.++ (str.to_re "h") (re.++ (str.to_re "=") (re.++ (str.to_re "\u{22}") (re.++ (str.to_re "4") (re.++ (str.to_re "\u{22}") (re.++ (str.to_re " ") (re.++ (str.to_re "p") (re.++ (str.to_re "a") (re.++ (str.to_re "t") (re.++ (str.to_re "t") (re.++ (str.to_re "e") (re.++ (str.to_re "r") (re.++ (str.to_re "n") (re.++ (str.to_re "=") (re.++ (str.to_re "\u{22}") (re.++ (re.union (re.++ (re.opt (str.to_re "01")) (re.range "0" "9")) (re.++ (str.to_re "2") (re.range "0" "3"))) (re.++ (re.range "0" "5") (re.++ (re.range "0" "9") (re.++ (str.to_re "\u{22}") (re.++ (str.to_re " ") (re.++ (str.to_re "p") (re.++ (str.to_re "a") (re.++ (str.to_re "t") (re.++ (str.to_re "t") (re.++ (str.to_re "e") (re.++ (str.to_re "r") (re.++ (str.to_re "n") (re.++ (str.to_re "=") (re.++ (str.to_re "\u{22}") ((_ re.loop 0 0) (re.diff re.allchar (str.to_re "\n")))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))) (re.++ (re.++ ((_ re.loop 4 4) (re.diff re.allchar (str.to_re "\n"))) (re.++ (str.to_re "\u{22}") (re.++ (str.to_re " ") (re.++ (str.to_re "v") (re.++ (str.to_re "a") (re.++ (str.to_re "l") (re.++ (str.to_re "u") (re.++ (str.to_re "e") (re.++ (str.to_re "=") (re.++ (str.to_re "\u{27}") (re.++ (re.opt (str.to_re "<")) (re.++ (str.to_re "p") (re.++ (str.to_re "h") (re.++ (str.to_re "p") (re.++ (str.to_re " ") (re.++ (str.to_re "e") (re.++ (str.to_re "c") (re.++ (str.to_re "h") (re.++ (str.to_re "o") (str.to_re " ")))))))))))))))))))) (re.++ (str.to_re "") (re.++ (str.to_re "o") (re.++ (str.to_re "b") (re.++ (str.to_re "j") (re.++ (str.to_re "R") (re.++ (str.to_re "e") (re.++ (str.to_re "s") (re.++ (str.to_re "u") (re.++ (str.to_re "l") (re.++ (str.to_re "t") (re.++ (re.union (str.to_re "\u{22}") (re.union (str.to_re "M") (re.union (str.to_re "O") (re.union (str.to_re "V") (re.union (str.to_re "I") (re.union (str.to_re "E") (str.to_re "\u{22}"))))))) (re.++ (str.to_re ";") (re.++ (re.opt (str.to_re " ")) (re.++ (str.to_re ">") (re.++ (str.to_re "\u{27}") (str.to_re ">"))))))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)