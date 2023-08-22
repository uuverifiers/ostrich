;test regex ([KQNBR]?([a-h]?[1-8]?x)?[a-h]([2-7]|[18](=[KQNBR])?)|0-0(-0)?)(\(ep\)|\+{1,2})?
(declare-const X String)
(assert (str.in_re X (re.++ (re.union (re.++ (re.opt (re.union (str.to_re "K") (re.union (str.to_re "Q") (re.union (str.to_re "N") (re.union (str.to_re "B") (str.to_re "R")))))) (re.++ (re.opt (re.++ (re.opt (re.range "a" "h")) (re.++ (re.opt (re.range "1" "8")) (str.to_re "x")))) (re.++ (re.range "a" "h") (re.union (re.range "2" "7") (re.++ (str.to_re "18") (re.opt (re.++ (str.to_re "=") (re.union (str.to_re "K") (re.union (str.to_re "Q") (re.union (str.to_re "N") (re.union (str.to_re "B") (str.to_re "R")))))))))))) (re.++ (str.to_re "0") (re.++ (str.to_re "-") (re.++ (str.to_re "0") (re.opt (re.++ (str.to_re "-") (str.to_re "0"))))))) (re.opt (re.union (re.++ (str.to_re "(") (re.++ (str.to_re "e") (re.++ (str.to_re "p") (str.to_re ")")))) ((_ re.loop 1 2) (str.to_re "+")))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)