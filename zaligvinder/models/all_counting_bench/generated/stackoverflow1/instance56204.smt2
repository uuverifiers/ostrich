;test regex ([\*\t])+(.{2,3}),\s?.[A,R,T,RS,RSS]{1,3}\.?\n.*
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (re.+ (re.union (str.to_re "*") (str.to_re "\u{09}"))) ((_ re.loop 2 3) (re.diff re.allchar (str.to_re "\n")))) (re.++ (str.to_re ",") (re.++ (re.opt (re.union (str.to_re " ") (re.union (str.to_re "\u{0b}") (re.union (str.to_re "\u{0a}") (re.union (str.to_re "\u{0d}") (re.union (str.to_re "\u{09}") (str.to_re "\u{0c}"))))))) (re.++ (re.diff re.allchar (str.to_re "\n")) (re.++ ((_ re.loop 1 3) (re.union (str.to_re "A") (re.union (str.to_re ",") (re.union (str.to_re "R") (re.union (str.to_re ",") (re.union (str.to_re "T") (re.union (str.to_re ",") (re.union (str.to_re "R") (re.union (str.to_re "S") (re.union (str.to_re ",") (re.union (str.to_re "R") (re.union (str.to_re "S") (str.to_re "S"))))))))))))) (re.++ (re.opt (str.to_re ".")) (re.++ (str.to_re "\u{0a}") (re.* (re.diff re.allchar (str.to_re "\n"))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)