;test regex driver.findElement(By.id("j_idt[0-9]{2}"));
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "d") (re.++ (str.to_re "r") (re.++ (str.to_re "i") (re.++ (str.to_re "v") (re.++ (str.to_re "e") (re.++ (str.to_re "r") (re.++ (re.diff re.allchar (str.to_re "\n")) (re.++ (str.to_re "f") (re.++ (str.to_re "i") (re.++ (str.to_re "n") (re.++ (str.to_re "d") (re.++ (str.to_re "E") (re.++ (str.to_re "l") (re.++ (str.to_re "e") (re.++ (str.to_re "m") (re.++ (str.to_re "e") (re.++ (str.to_re "n") (re.++ (str.to_re "t") (re.++ (re.++ (str.to_re "B") (re.++ (str.to_re "y") (re.++ (re.diff re.allchar (str.to_re "\n")) (re.++ (str.to_re "i") (re.++ (str.to_re "d") (re.++ (str.to_re "\u{22}") (re.++ (str.to_re "j") (re.++ (str.to_re "_") (re.++ (str.to_re "i") (re.++ (str.to_re "d") (re.++ (str.to_re "t") (re.++ ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re "\u{22}"))))))))))))) (str.to_re ";"))))))))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)