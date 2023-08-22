;test regex ^(SomeFile|ThatOtherFile)_.*?_([0-9]{8}).*$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ (re.union (re.++ (str.to_re "S") (re.++ (str.to_re "o") (re.++ (str.to_re "m") (re.++ (str.to_re "e") (re.++ (str.to_re "F") (re.++ (str.to_re "i") (re.++ (str.to_re "l") (str.to_re "e")))))))) (re.++ (str.to_re "T") (re.++ (str.to_re "h") (re.++ (str.to_re "a") (re.++ (str.to_re "t") (re.++ (str.to_re "O") (re.++ (str.to_re "t") (re.++ (str.to_re "h") (re.++ (str.to_re "e") (re.++ (str.to_re "r") (re.++ (str.to_re "F") (re.++ (str.to_re "i") (re.++ (str.to_re "l") (str.to_re "e")))))))))))))) (re.++ (str.to_re "_") (re.++ (re.* (re.diff re.allchar (str.to_re "\n"))) (re.++ (str.to_re "_") (re.++ ((_ re.loop 8 8) (re.range "0" "9")) (re.* (re.diff re.allchar (str.to_re "\n"))))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)