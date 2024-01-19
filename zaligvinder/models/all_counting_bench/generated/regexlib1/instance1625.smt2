;test regex ^((0{1})?([0-3]{0,1}))(\.[0-9]{0,2})?$|^(4)(\.[0]{1,2})?$|^((0{1})?([0-4]{0,1}))(\.)?$
(declare-const X String)
(assert (str.in_re X (re.union (re.union (re.++ (re.++ (str.to_re "") (re.++ (re.++ (re.opt ((_ re.loop 1 1) (str.to_re "0"))) ((_ re.loop 0 1) (re.range "0" "3"))) (re.opt (re.++ (str.to_re ".") ((_ re.loop 0 2) (re.range "0" "9")))))) (str.to_re "")) (re.++ (re.++ (str.to_re "") (re.++ (str.to_re "4") (re.opt (re.++ (str.to_re ".") ((_ re.loop 1 2) (str.to_re "0")))))) (str.to_re ""))) (re.++ (re.++ (str.to_re "") (re.++ (re.++ (re.opt ((_ re.loop 1 1) (str.to_re "0"))) ((_ re.loop 0 1) (re.range "0" "4"))) (re.opt (str.to_re ".")))) (str.to_re "")))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)