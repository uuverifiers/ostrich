;test regex ~<(/){0,1}.*?( /){0,1}>|(tag://\w*\||user://[0-9]*\|)~
(declare-const X String)
(assert (str.in_re X (re.union (re.++ (str.to_re "~") (re.++ (str.to_re "<") (re.++ ((_ re.loop 0 1) (str.to_re "/")) (re.++ (re.* (re.diff re.allchar (str.to_re "\n"))) (re.++ ((_ re.loop 0 1) (re.++ (str.to_re " ") (str.to_re "/"))) (str.to_re ">")))))) (re.++ (re.union (re.++ (str.to_re "t") (re.++ (str.to_re "a") (re.++ (str.to_re "g") (re.++ (str.to_re ":") (re.++ (str.to_re "/") (re.++ (str.to_re "/") (re.++ (re.* (re.union (re.range "a" "z") (re.union (re.range "A" "Z") (re.union (re.range "0" "9") (str.to_re "_"))))) (str.to_re "|")))))))) (re.++ (str.to_re "u") (re.++ (str.to_re "s") (re.++ (str.to_re "e") (re.++ (str.to_re "r") (re.++ (str.to_re ":") (re.++ (str.to_re "/") (re.++ (str.to_re "/") (re.++ (re.* (re.range "0" "9")) (str.to_re "|")))))))))) (str.to_re "~")))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)