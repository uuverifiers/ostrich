;test regex df$new_col <- as.numeric(sub(".*\\#([0-9]{2,4}).*", "\\1", df$text))
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "d") (str.to_re "f")) (re.++ (str.to_re "") (re.++ (str.to_re "n") (re.++ (str.to_re "e") (re.++ (str.to_re "w") (re.++ (str.to_re "_") (re.++ (str.to_re "c") (re.++ (str.to_re "o") (re.++ (str.to_re "l") (re.++ (str.to_re " ") (re.++ (str.to_re "<") (re.++ (str.to_re "-") (re.++ (str.to_re " ") (re.++ (str.to_re "a") (re.++ (str.to_re "s") (re.++ (re.diff re.allchar (str.to_re "\n")) (re.++ (str.to_re "n") (re.++ (str.to_re "u") (re.++ (str.to_re "m") (re.++ (str.to_re "e") (re.++ (str.to_re "r") (re.++ (str.to_re "i") (re.++ (str.to_re "c") (re.++ (str.to_re "s") (re.++ (str.to_re "u") (re.++ (str.to_re "b") (re.++ (re.++ (re.++ (re.++ (str.to_re "\u{22}") (re.++ (re.* (re.diff re.allchar (str.to_re "\n"))) (re.++ (str.to_re "\\") (re.++ (str.to_re "#") (re.++ ((_ re.loop 2 4) (re.range "0" "9")) (re.++ (re.* (re.diff re.allchar (str.to_re "\n"))) (str.to_re "\u{22}"))))))) (re.++ (str.to_re ",") (re.++ (str.to_re " ") (re.++ (str.to_re "\u{22}") (re.++ (str.to_re "\\") (re.++ (str.to_re "1") (str.to_re "\u{22}"))))))) (re.++ (str.to_re ",") (re.++ (str.to_re " ") (re.++ (str.to_re "d") (str.to_re "f"))))) (re.++ (str.to_re "") (re.++ (str.to_re "t") (re.++ (str.to_re "e") (re.++ (str.to_re "x") (str.to_re "t"))))))))))))))))))))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)