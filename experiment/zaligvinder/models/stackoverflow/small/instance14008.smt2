;test regex formattedText="$(ExecID:R/.*(/\d{6}$)/$1/)"
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "f") (re.++ (str.to_re "o") (re.++ (str.to_re "r") (re.++ (str.to_re "m") (re.++ (str.to_re "a") (re.++ (str.to_re "t") (re.++ (str.to_re "t") (re.++ (str.to_re "e") (re.++ (str.to_re "d") (re.++ (str.to_re "T") (re.++ (str.to_re "e") (re.++ (str.to_re "x") (re.++ (str.to_re "t") (re.++ (str.to_re "=") (str.to_re "\u{22}"))))))))))))))) (re.++ (str.to_re "") (re.++ (re.++ (re.++ (str.to_re "E") (re.++ (str.to_re "x") (re.++ (str.to_re "e") (re.++ (str.to_re "c") (re.++ (str.to_re "I") (re.++ (str.to_re "D") (re.++ (str.to_re ":") (re.++ (str.to_re "R") (re.++ (str.to_re "/") (re.++ (re.* (re.diff re.allchar (str.to_re "\n"))) (re.++ (re.++ (re.++ (str.to_re "/") ((_ re.loop 6 6) (re.range "0" "9"))) (str.to_re "")) (str.to_re "/")))))))))))) (re.++ (str.to_re "") (re.++ (str.to_re "1") (str.to_re "/")))) (str.to_re "\u{22}"))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)