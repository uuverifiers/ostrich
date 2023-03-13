;test regex ([A-Da-d]{1}[1-9]{1}|[A-Da-d]{1}[1]{1}[0-6]{1})
(declare-const X String)
(assert (str.in_re X (re.union (re.++ ((_ re.loop 1 1) (re.union (re.range "A" "D") (re.range "a" "d"))) ((_ re.loop 1 1) (re.range "1" "9"))) (re.++ ((_ re.loop 1 1) (re.union (re.range "A" "D") (re.range "a" "d"))) (re.++ ((_ re.loop 1 1) (str.to_re "1")) ((_ re.loop 1 1) (re.range "0" "6")))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)