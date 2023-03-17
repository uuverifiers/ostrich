;test regex ack 'cout.+(.+,){4,}' --cpp
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "a") (re.++ (str.to_re "c") (re.++ (str.to_re "k") (re.++ (str.to_re " ") (re.++ (str.to_re "\u{27}") (re.++ (str.to_re "c") (re.++ (str.to_re "o") (re.++ (str.to_re "u") (re.++ (str.to_re "t") (re.++ (re.+ (re.diff re.allchar (str.to_re "\n"))) (re.++ (re.++ (re.* (re.++ (re.+ (re.diff re.allchar (str.to_re "\n"))) (str.to_re ","))) ((_ re.loop 4 4) (re.++ (re.+ (re.diff re.allchar (str.to_re "\n"))) (str.to_re ",")))) (re.++ (str.to_re "\u{27}") (re.++ (str.to_re " ") (re.++ (str.to_re "-") (re.++ (str.to_re "-") (re.++ (str.to_re "c") (re.++ (str.to_re "p") (str.to_re "p"))))))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)