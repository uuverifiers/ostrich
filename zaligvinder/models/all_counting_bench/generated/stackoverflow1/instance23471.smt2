;test regex :%s/\v^(\d{2}):(\d{2})>/\=submatch(1) * 60 + submatch(2)/
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re ":") (re.++ (str.to_re "%") (re.++ (str.to_re "s") (re.++ (str.to_re "/") (str.to_re "\u{0B}"))))) (re.++ (str.to_re "") (re.++ ((_ re.loop 2 2) (re.range "0" "9")) (re.++ (str.to_re ":") (re.++ ((_ re.loop 2 2) (re.range "0" "9")) (re.++ (str.to_re ">") (re.++ (str.to_re "/") (re.++ (str.to_re "=") (re.++ (str.to_re "s") (re.++ (str.to_re "u") (re.++ (str.to_re "b") (re.++ (str.to_re "m") (re.++ (str.to_re "a") (re.++ (str.to_re "t") (re.++ (str.to_re "c") (re.++ (str.to_re "h") (re.++ (str.to_re "1") (re.++ (re.* (str.to_re " ")) (re.++ (str.to_re " ") (re.++ (str.to_re "60") (re.++ (re.+ (str.to_re " ")) (re.++ (str.to_re " ") (re.++ (str.to_re "s") (re.++ (str.to_re "u") (re.++ (str.to_re "b") (re.++ (str.to_re "m") (re.++ (str.to_re "a") (re.++ (str.to_re "t") (re.++ (str.to_re "c") (re.++ (str.to_re "h") (re.++ (str.to_re "2") (str.to_re "/"))))))))))))))))))))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)