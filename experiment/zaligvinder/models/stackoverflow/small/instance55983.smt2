;test regex bc2.{23}13|b53.{23}92|39f.{23}bb|eb7.{23}7a|80b.{23}22
(declare-const X String)
(assert (str.in_re X (re.union (re.union (re.union (re.union (re.++ (str.to_re "b") (re.++ (str.to_re "c") (re.++ (str.to_re "2") (re.++ ((_ re.loop 23 23) (re.diff re.allchar (str.to_re "\n"))) (str.to_re "13"))))) (re.++ (str.to_re "b") (re.++ (str.to_re "53") (re.++ ((_ re.loop 23 23) (re.diff re.allchar (str.to_re "\n"))) (str.to_re "92"))))) (re.++ (str.to_re "39") (re.++ (str.to_re "f") (re.++ ((_ re.loop 23 23) (re.diff re.allchar (str.to_re "\n"))) (re.++ (str.to_re "b") (str.to_re "b")))))) (re.++ (str.to_re "e") (re.++ (str.to_re "b") (re.++ (str.to_re "7") (re.++ ((_ re.loop 23 23) (re.diff re.allchar (str.to_re "\n"))) (re.++ (str.to_re "7") (str.to_re "a"))))))) (re.++ (str.to_re "80") (re.++ (str.to_re "b") (re.++ ((_ re.loop 23 23) (re.diff re.allchar (str.to_re "\n"))) (str.to_re "22")))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)