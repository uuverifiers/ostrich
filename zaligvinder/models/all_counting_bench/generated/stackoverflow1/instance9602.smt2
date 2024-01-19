;test regex DB((\d{1,3})|(1000))\.DB(X|B|D|W)((\d{1,3})|(1000))\.((\d{1})|(10))
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "D") (re.++ (str.to_re "B") (re.++ (re.union ((_ re.loop 1 3) (re.range "0" "9")) (str.to_re "1000")) (re.++ (str.to_re ".") (re.++ (str.to_re "D") (re.++ (str.to_re "B") (re.++ (re.union (re.union (re.union (str.to_re "X") (str.to_re "B")) (str.to_re "D")) (str.to_re "W")) (re.++ (re.union ((_ re.loop 1 3) (re.range "0" "9")) (str.to_re "1000")) (re.++ (str.to_re ".") (re.union ((_ re.loop 1 1) (re.range "0" "9")) (str.to_re "10")))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)