;test regex <script src='\/js\/app.[a-f0-9]{32}.js'><\/script>
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "<") (re.++ (str.to_re "s") (re.++ (str.to_re "c") (re.++ (str.to_re "r") (re.++ (str.to_re "i") (re.++ (str.to_re "p") (re.++ (str.to_re "t") (re.++ (str.to_re " ") (re.++ (str.to_re "s") (re.++ (str.to_re "r") (re.++ (str.to_re "c") (re.++ (str.to_re "=") (re.++ (str.to_re "\u{27}") (re.++ (str.to_re "/") (re.++ (str.to_re "j") (re.++ (str.to_re "s") (re.++ (str.to_re "/") (re.++ (str.to_re "a") (re.++ (str.to_re "p") (re.++ (str.to_re "p") (re.++ (re.diff re.allchar (str.to_re "\n")) (re.++ ((_ re.loop 32 32) (re.union (re.range "a" "f") (re.range "0" "9"))) (re.++ (re.diff re.allchar (str.to_re "\n")) (re.++ (str.to_re "j") (re.++ (str.to_re "s") (re.++ (str.to_re "\u{27}") (re.++ (str.to_re ">") (re.++ (str.to_re "<") (re.++ (str.to_re "/") (re.++ (str.to_re "s") (re.++ (str.to_re "c") (re.++ (str.to_re "r") (re.++ (str.to_re "i") (re.++ (str.to_re "p") (re.++ (str.to_re "t") (str.to_re ">"))))))))))))))))))))))))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)