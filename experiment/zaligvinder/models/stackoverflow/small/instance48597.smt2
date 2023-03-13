;test regex .*?(%(?:d|m|Y)(?:.*%(?:d|m|Y)){0,2}).*
(declare-const X String)
(assert (str.in_re X (re.++ (re.* (re.diff re.allchar (str.to_re "\n"))) (re.++ (re.++ (str.to_re "%") (re.++ (re.union (re.union (str.to_re "d") (str.to_re "m")) (str.to_re "Y")) ((_ re.loop 0 2) (re.++ (re.* (re.diff re.allchar (str.to_re "\n"))) (re.++ (str.to_re "%") (re.union (re.union (str.to_re "d") (str.to_re "m")) (str.to_re "Y"))))))) (re.* (re.diff re.allchar (str.to_re "\n")))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)