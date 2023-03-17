;test regex (((4[0-6])|(11[5-9]|12[0-5]))(\.|)?([0-9]{1,10})?(, )?)+
(declare-const X String)
(assert (str.in_re X (re.+ (re.++ (re.union (re.++ (str.to_re "4") (re.range "0" "6")) (re.union (re.++ (str.to_re "11") (re.range "5" "9")) (re.++ (str.to_re "12") (re.range "0" "5")))) (re.++ (re.opt (re.union (re.++ (str.to_re "") (str.to_re ".")) (str.to_re ""))) (re.++ (re.opt ((_ re.loop 1 10) (re.range "0" "9"))) (re.opt (re.++ (str.to_re ",") (str.to_re " ")))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)