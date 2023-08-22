;test regex ^((4\d{3})|(5[1-5]\d{2}))(-?|\040?)(\d{4}(-?|\040?)){3}|^(3[4,7]\d{2})(-?|\040?)\d{6}(-?|\040?)\d{5}
(declare-const X String)
(assert (str.in_re X (re.union (re.++ (str.to_re "") (re.++ (re.union (re.++ (str.to_re "4") ((_ re.loop 3 3) (re.range "0" "9"))) (re.++ (str.to_re "5") (re.++ (re.range "1" "5") ((_ re.loop 2 2) (re.range "0" "9"))))) (re.++ (re.union (re.opt (str.to_re "-")) (re.opt (str.to_re "\u{0020}"))) ((_ re.loop 3 3) (re.++ ((_ re.loop 4 4) (re.range "0" "9")) (re.union (re.opt (str.to_re "-")) (re.opt (str.to_re "\u{0020}")))))))) (re.++ (str.to_re "") (re.++ (re.++ (str.to_re "3") (re.++ (re.union (str.to_re "4") (re.union (str.to_re ",") (str.to_re "7"))) ((_ re.loop 2 2) (re.range "0" "9")))) (re.++ (re.union (re.opt (str.to_re "-")) (re.opt (str.to_re "\u{0020}"))) (re.++ ((_ re.loop 6 6) (re.range "0" "9")) (re.++ (re.union (re.opt (str.to_re "-")) (re.opt (str.to_re "\u{0020}"))) ((_ re.loop 5 5) (re.range "0" "9"))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)