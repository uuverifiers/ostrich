;test regex rename -n 's/^.+?([\w-]{11})\.mp4$/$1/' *.mp4
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (re.++ (re.++ (str.to_re "r") (re.++ (str.to_re "e") (re.++ (str.to_re "n") (re.++ (str.to_re "a") (re.++ (str.to_re "m") (re.++ (str.to_re "e") (re.++ (str.to_re " ") (re.++ (str.to_re "-") (re.++ (str.to_re "n") (re.++ (str.to_re " ") (re.++ (str.to_re "\u{27}") (re.++ (str.to_re "s") (str.to_re "/"))))))))))))) (re.++ (str.to_re "") (re.++ (re.+ (re.diff re.allchar (str.to_re "\n"))) (re.++ ((_ re.loop 11 11) (re.union (re.union (re.range "a" "z") (re.union (re.range "A" "Z") (re.union (re.range "0" "9") (str.to_re "_")))) (str.to_re "-"))) (re.++ (str.to_re ".") (re.++ (str.to_re "m") (re.++ (str.to_re "p") (str.to_re "4")))))))) (re.++ (str.to_re "") (str.to_re "/"))) (re.++ (str.to_re "") (re.++ (str.to_re "1") (re.++ (str.to_re "/") (re.++ (str.to_re "\u{27}") (re.++ (re.* (str.to_re " ")) (re.++ (re.diff re.allchar (str.to_re "\n")) (re.++ (str.to_re "m") (re.++ (str.to_re "p") (str.to_re "4"))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)