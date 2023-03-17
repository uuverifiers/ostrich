;test regex (A1|A2|A3|A4).{0,50}(B1|B2|B3).{0,200}(word1|word2)
(declare-const X String)
(assert (str.in_re X (re.++ (re.union (re.union (re.union (re.++ (str.to_re "A") (str.to_re "1")) (re.++ (str.to_re "A") (str.to_re "2"))) (re.++ (str.to_re "A") (str.to_re "3"))) (re.++ (str.to_re "A") (str.to_re "4"))) (re.++ ((_ re.loop 0 50) (re.diff re.allchar (str.to_re "\n"))) (re.++ (re.union (re.union (re.++ (str.to_re "B") (str.to_re "1")) (re.++ (str.to_re "B") (str.to_re "2"))) (re.++ (str.to_re "B") (str.to_re "3"))) (re.++ ((_ re.loop 0 200) (re.diff re.allchar (str.to_re "\n"))) (re.union (re.++ (str.to_re "w") (re.++ (str.to_re "o") (re.++ (str.to_re "r") (re.++ (str.to_re "d") (str.to_re "1"))))) (re.++ (str.to_re "w") (re.++ (str.to_re "o") (re.++ (str.to_re "r") (re.++ (str.to_re "d") (str.to_re "2"))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 50 (str.len X)))
(check-sat)
(get-model)