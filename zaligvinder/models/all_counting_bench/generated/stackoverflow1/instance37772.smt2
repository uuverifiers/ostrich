;test regex label_name = "${1}_${2}_${3}_${6}"
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (re.++ (re.++ (re.++ (str.to_re "l") (re.++ (str.to_re "a") (re.++ (str.to_re "b") (re.++ (str.to_re "e") (re.++ (str.to_re "l") (re.++ (str.to_re "_") (re.++ (str.to_re "n") (re.++ (str.to_re "a") (re.++ (str.to_re "m") (re.++ (str.to_re "e") (re.++ (str.to_re " ") (re.++ (str.to_re "=") (re.++ (str.to_re " ") (str.to_re "\u{22}")))))))))))))) (re.++ ((_ re.loop 1 1) (str.to_re "")) (str.to_re "_"))) (re.++ ((_ re.loop 2 2) (str.to_re "")) (str.to_re "_"))) (re.++ ((_ re.loop 3 3) (str.to_re "")) (str.to_re "_"))) (re.++ ((_ re.loop 6 6) (str.to_re "")) (str.to_re "\u{22}")))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)