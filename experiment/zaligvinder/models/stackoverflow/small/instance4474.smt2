;test regex [a-z]{1}[a-zA-Z0-9]*@.*\.(edu|org|com)$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ ((_ re.loop 1 1) (re.range "a" "z")) (re.++ (re.* (re.union (re.range "a" "z") (re.union (re.range "A" "Z") (re.range "0" "9")))) (re.++ (str.to_re "@") (re.++ (re.* (re.diff re.allchar (str.to_re "\n"))) (re.++ (str.to_re ".") (re.union (re.union (re.++ (str.to_re "e") (re.++ (str.to_re "d") (str.to_re "u"))) (re.++ (str.to_re "o") (re.++ (str.to_re "r") (str.to_re "g")))) (re.++ (str.to_re "c") (re.++ (str.to_re "o") (str.to_re "m"))))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)