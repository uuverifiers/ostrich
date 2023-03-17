;test regex 0${1}3${2}0${3}3${4}5${5}5${6}5${7}5${8}1${9}1${10}1
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (re.++ (re.++ (re.++ (re.++ (re.++ (re.++ (re.++ (re.++ (str.to_re "0") (re.++ ((_ re.loop 1 1) (str.to_re "")) (str.to_re "3"))) (re.++ ((_ re.loop 2 2) (str.to_re "")) (str.to_re "0"))) (re.++ ((_ re.loop 3 3) (str.to_re "")) (str.to_re "3"))) (re.++ ((_ re.loop 4 4) (str.to_re "")) (str.to_re "5"))) (re.++ ((_ re.loop 5 5) (str.to_re "")) (str.to_re "5"))) (re.++ ((_ re.loop 6 6) (str.to_re "")) (str.to_re "5"))) (re.++ ((_ re.loop 7 7) (str.to_re "")) (str.to_re "5"))) (re.++ ((_ re.loop 8 8) (str.to_re "")) (str.to_re "1"))) (re.++ ((_ re.loop 9 9) (str.to_re "")) (str.to_re "1"))) (re.++ ((_ re.loop 10 10) (str.to_re "")) (str.to_re "1")))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 50 (str.len X)))
(check-sat)
(get-model)