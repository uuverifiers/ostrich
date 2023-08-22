;test regex $line =~ s/TIME="[0-9]{8}\.[0-9]{7}"/TIME="00000000.0000000"/g
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "") (re.++ (str.to_re "l") (re.++ (str.to_re "i") (re.++ (str.to_re "n") (re.++ (str.to_re "e") (re.++ (str.to_re " ") (re.++ (str.to_re "=") (re.++ (str.to_re "~") (re.++ (str.to_re " ") (re.++ (str.to_re "s") (re.++ (str.to_re "/") (re.++ (str.to_re "T") (re.++ (str.to_re "I") (re.++ (str.to_re "M") (re.++ (str.to_re "E") (re.++ (str.to_re "=") (re.++ (str.to_re "\u{22}") (re.++ ((_ re.loop 8 8) (re.range "0" "9")) (re.++ (str.to_re ".") (re.++ ((_ re.loop 7 7) (re.range "0" "9")) (re.++ (str.to_re "\u{22}") (re.++ (str.to_re "/") (re.++ (str.to_re "T") (re.++ (str.to_re "I") (re.++ (str.to_re "M") (re.++ (str.to_re "E") (re.++ (str.to_re "=") (re.++ (str.to_re "\u{22}") (re.++ (str.to_re "00000000") (re.++ (re.diff re.allchar (str.to_re "\n")) (re.++ (str.to_re "0000000") (re.++ (str.to_re "\u{22}") (re.++ (str.to_re "/") (str.to_re "g"))))))))))))))))))))))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)