;test regex <audio id="element\d+">\s*(?:<source src="([^"]+/([^/]+))\.(mp3|wav)" type=[^>]+>\s*){2}</audio>
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "<") (re.++ (str.to_re "a") (re.++ (str.to_re "u") (re.++ (str.to_re "d") (re.++ (str.to_re "i") (re.++ (str.to_re "o") (re.++ (str.to_re " ") (re.++ (str.to_re "i") (re.++ (str.to_re "d") (re.++ (str.to_re "=") (re.++ (str.to_re "\u{22}") (re.++ (str.to_re "e") (re.++ (str.to_re "l") (re.++ (str.to_re "e") (re.++ (str.to_re "m") (re.++ (str.to_re "e") (re.++ (str.to_re "n") (re.++ (str.to_re "t") (re.++ (re.+ (re.range "0" "9")) (re.++ (str.to_re "\u{22}") (re.++ (str.to_re ">") (re.++ (re.* (re.union (str.to_re " ") (re.union (str.to_re "\u{0b}") (re.union (str.to_re "\u{0a}") (re.union (str.to_re "\u{0d}") (re.union (str.to_re "\u{09}") (str.to_re "\u{0c}"))))))) (re.++ ((_ re.loop 2 2) (re.++ (str.to_re "<") (re.++ (str.to_re "s") (re.++ (str.to_re "o") (re.++ (str.to_re "u") (re.++ (str.to_re "r") (re.++ (str.to_re "c") (re.++ (str.to_re "e") (re.++ (str.to_re " ") (re.++ (str.to_re "s") (re.++ (str.to_re "r") (re.++ (str.to_re "c") (re.++ (str.to_re "=") (re.++ (str.to_re "\u{22}") (re.++ (re.++ (re.+ (re.diff re.allchar (str.to_re "\u{22}"))) (re.++ (str.to_re "/") (re.+ (re.diff re.allchar (str.to_re "/"))))) (re.++ (str.to_re ".") (re.++ (re.union (re.++ (str.to_re "m") (re.++ (str.to_re "p") (str.to_re "3"))) (re.++ (str.to_re "w") (re.++ (str.to_re "a") (str.to_re "v")))) (re.++ (str.to_re "\u{22}") (re.++ (str.to_re " ") (re.++ (str.to_re "t") (re.++ (str.to_re "y") (re.++ (str.to_re "p") (re.++ (str.to_re "e") (re.++ (str.to_re "=") (re.++ (re.+ (re.diff re.allchar (str.to_re ">"))) (re.++ (str.to_re ">") (re.* (re.union (str.to_re " ") (re.union (str.to_re "\u{0b}") (re.union (str.to_re "\u{0a}") (re.union (str.to_re "\u{0d}") (re.union (str.to_re "\u{09}") (str.to_re "\u{0c}"))))))))))))))))))))))))))))))))) (re.++ (str.to_re "<") (re.++ (str.to_re "/") (re.++ (str.to_re "a") (re.++ (str.to_re "u") (re.++ (str.to_re "d") (re.++ (str.to_re "i") (re.++ (str.to_re "o") (str.to_re ">")))))))))))))))))))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)