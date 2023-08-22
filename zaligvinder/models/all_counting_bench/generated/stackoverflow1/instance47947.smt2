;test regex ^(\+44\\s?7\\d{3}|\(?07\\d{3}\)?)\\s?\\d{3}\\s?\\d{3}$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ (re.union (re.++ (str.to_re "+") (re.++ (str.to_re "44") (re.++ (str.to_re "\\") (re.++ (re.opt (str.to_re "s")) (re.++ (str.to_re "7") (re.++ (str.to_re "\\") ((_ re.loop 3 3) (str.to_re "d")))))))) (re.++ (re.opt (str.to_re "(")) (re.++ (str.to_re "07") (re.++ (str.to_re "\\") (re.++ ((_ re.loop 3 3) (str.to_re "d")) (re.opt (str.to_re ")"))))))) (re.++ (str.to_re "\\") (re.++ (re.opt (str.to_re "s")) (re.++ (str.to_re "\\") (re.++ ((_ re.loop 3 3) (str.to_re "d")) (re.++ (str.to_re "\\") (re.++ (re.opt (str.to_re "s")) (re.++ (str.to_re "\\") ((_ re.loop 3 3) (str.to_re "d"))))))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)