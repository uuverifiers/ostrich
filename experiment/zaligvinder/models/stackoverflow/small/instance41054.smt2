;test regex df.id.str.extract(r'[.-]([0-9]{5})[.-]?')
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "d") (re.++ (str.to_re "f") (re.++ (re.diff re.allchar (str.to_re "\n")) (re.++ (str.to_re "i") (re.++ (str.to_re "d") (re.++ (re.diff re.allchar (str.to_re "\n")) (re.++ (str.to_re "s") (re.++ (str.to_re "t") (re.++ (str.to_re "r") (re.++ (re.diff re.allchar (str.to_re "\n")) (re.++ (str.to_re "e") (re.++ (str.to_re "x") (re.++ (str.to_re "t") (re.++ (str.to_re "r") (re.++ (str.to_re "a") (re.++ (str.to_re "c") (re.++ (str.to_re "t") (re.++ (str.to_re "r") (re.++ (str.to_re "\u{27}") (re.++ (re.union (str.to_re ".") (str.to_re "-")) (re.++ ((_ re.loop 5 5) (re.range "0" "9")) (re.++ (re.opt (re.union (str.to_re ".") (str.to_re "-"))) (str.to_re "\u{27}")))))))))))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)