;test regex (.*(\{myVariable1\}|<html>)){2}
(declare-const X String)
(assert (str.in_re X ((_ re.loop 2 2) (re.++ (re.* (re.diff re.allchar (str.to_re "\n"))) (re.union (re.++ (str.to_re "{") (re.++ (str.to_re "m") (re.++ (str.to_re "y") (re.++ (str.to_re "V") (re.++ (str.to_re "a") (re.++ (str.to_re "r") (re.++ (str.to_re "i") (re.++ (str.to_re "a") (re.++ (str.to_re "b") (re.++ (str.to_re "l") (re.++ (str.to_re "e") (re.++ (str.to_re "1") (str.to_re "}"))))))))))))) (re.++ (str.to_re "<") (re.++ (str.to_re "h") (re.++ (str.to_re "t") (re.++ (str.to_re "m") (re.++ (str.to_re "l") (str.to_re ">")))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)