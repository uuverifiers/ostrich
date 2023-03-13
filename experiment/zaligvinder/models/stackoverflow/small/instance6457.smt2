;test regex ([0-9]{2}(001|002|003|004|005|006|007... |366|501|...|866)[0-9]{4}[x|X]$)
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ ((_ re.loop 2 2) (re.range "0" "9")) (re.++ (re.union (re.union (re.union (re.union (re.union (re.union (re.union (re.union (re.union (re.union (str.to_re "001") (str.to_re "002")) (str.to_re "003")) (str.to_re "004")) (str.to_re "005")) (str.to_re "006")) (re.++ (str.to_re "007") (re.++ (re.diff re.allchar (str.to_re "\n")) (re.++ (re.diff re.allchar (str.to_re "\n")) (re.++ (re.diff re.allchar (str.to_re "\n")) (str.to_re " ")))))) (str.to_re "366")) (str.to_re "501")) (re.++ (re.diff re.allchar (str.to_re "\n")) (re.++ (re.diff re.allchar (str.to_re "\n")) (re.diff re.allchar (str.to_re "\n"))))) (str.to_re "866")) (re.++ ((_ re.loop 4 4) (re.range "0" "9")) (re.union (str.to_re "x") (re.union (str.to_re "|") (str.to_re "X")))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)