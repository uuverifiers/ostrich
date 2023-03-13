;test regex ruby md5.rb -h "[0-9a-f]{32}"
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "r") (re.++ (str.to_re "u") (re.++ (str.to_re "b") (re.++ (str.to_re "y") (re.++ (str.to_re " ") (re.++ (str.to_re "m") (re.++ (str.to_re "d") (re.++ (str.to_re "5") (re.++ (re.diff re.allchar (str.to_re "\n")) (re.++ (str.to_re "r") (re.++ (str.to_re "b") (re.++ (str.to_re " ") (re.++ (str.to_re "-") (re.++ (str.to_re "h") (re.++ (str.to_re " ") (re.++ (str.to_re "\u{22}") (re.++ ((_ re.loop 32 32) (re.union (re.range "0" "9") (re.range "a" "f"))) (str.to_re "\u{22}"))))))))))))))))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)