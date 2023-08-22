;test regex \A\h{2}([:\-]?\h{2}){5}\z|\A\h{2}([:\-]?\h{2}){7}\z
(declare-const X String)
(assert (str.in_re X (re.union (re.++ (str.to_re "A") (re.++ ((_ re.loop 2 2) (str.to_re "h")) (re.++ ((_ re.loop 5 5) (re.++ (re.opt (re.union (str.to_re ":") (str.to_re "-"))) ((_ re.loop 2 2) (str.to_re "h")))) (str.to_re "z")))) (re.++ (str.to_re "A") (re.++ ((_ re.loop 2 2) (str.to_re "h")) (re.++ ((_ re.loop 7 7) (re.++ (re.opt (re.union (str.to_re ":") (str.to_re "-"))) ((_ re.loop 2 2) (str.to_re "h")))) (str.to_re "z")))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)