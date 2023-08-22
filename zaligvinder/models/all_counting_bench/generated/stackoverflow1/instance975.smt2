;test regex (.*)_[0-9]{4}_[0-9]{3}([0-9][vr])?((-s)0{0,2}+([0-9][vr]))?
(declare-const X String)
(assert (str.in_re X (re.++ (re.* (re.diff re.allchar (str.to_re "\n"))) (re.++ (str.to_re "_") (re.++ ((_ re.loop 4 4) (re.range "0" "9")) (re.++ (str.to_re "_") (re.++ ((_ re.loop 3 3) (re.range "0" "9")) (re.++ (re.opt (re.++ (re.range "0" "9") (re.union (str.to_re "v") (str.to_re "r")))) (re.opt (re.++ (re.++ (str.to_re "-") (str.to_re "s")) (re.++ (re.+ ((_ re.loop 0 2) (str.to_re "0"))) (re.++ (re.range "0" "9") (re.union (str.to_re "v") (str.to_re "r"))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)