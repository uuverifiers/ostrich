;test regex [Ss]uc{1,}es{1,}ful{1,}
(declare-const X String)
(assert (str.in_re X (re.++ (re.union (str.to_re "S") (str.to_re "s")) (re.++ (str.to_re "u") (re.++ (re.++ (re.* (str.to_re "c")) ((_ re.loop 1 1) (str.to_re "c"))) (re.++ (str.to_re "e") (re.++ (re.++ (re.* (str.to_re "s")) ((_ re.loop 1 1) (str.to_re "s"))) (re.++ (str.to_re "f") (re.++ (str.to_re "u") (re.++ (re.* (str.to_re "l")) ((_ re.loop 1 1) (str.to_re "l"))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)