;test regex ^((?:[^,]+,){8})(.+)((?:,[^,]*){2})$ and replace with $1"$2"$3
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (re.++ (re.++ (re.++ (str.to_re "") (re.++ ((_ re.loop 8 8) (re.++ (re.+ (re.diff re.allchar (str.to_re ","))) (str.to_re ","))) (re.++ (re.+ (re.diff re.allchar (str.to_re "\n"))) ((_ re.loop 2 2) (re.++ (str.to_re ",") (re.* (re.diff re.allchar (str.to_re ",")))))))) (re.++ (str.to_re "") (re.++ (str.to_re " ") (re.++ (str.to_re "a") (re.++ (str.to_re "n") (re.++ (str.to_re "d") (re.++ (str.to_re " ") (re.++ (str.to_re "r") (re.++ (str.to_re "e") (re.++ (str.to_re "p") (re.++ (str.to_re "l") (re.++ (str.to_re "a") (re.++ (str.to_re "c") (re.++ (str.to_re "e") (re.++ (str.to_re " ") (re.++ (str.to_re "w") (re.++ (str.to_re "i") (re.++ (str.to_re "t") (re.++ (str.to_re "h") (str.to_re " ")))))))))))))))))))) (re.++ (str.to_re "") (re.++ (str.to_re "1") (str.to_re "\u{22}")))) (re.++ (str.to_re "") (re.++ (str.to_re "2") (str.to_re "\u{22}")))) (re.++ (str.to_re "") (str.to_re "3")))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)