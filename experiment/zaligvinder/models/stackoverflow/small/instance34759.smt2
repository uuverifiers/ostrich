;test regex le[\,]{0,}[.]?m
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "l") (re.++ (str.to_re "e") (re.++ (re.++ (re.* (str.to_re ",")) ((_ re.loop 0 0) (str.to_re ","))) (re.++ (re.opt (str.to_re ".")) (str.to_re "m")))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)