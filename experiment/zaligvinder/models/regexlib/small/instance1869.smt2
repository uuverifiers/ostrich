;test regex ^(0|[-]{1}([1-9]{1}[0-9]{0,1}|[1]{1}([0-1]{1}[0-9]{1}|[2]{1}[0-8]{1}))|(\+)?([1-9]{1}[0-9]{0,1}|[1]{1}([0-1]{1}[0-9]{1}|[2]{1}[0-7]{1})))$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.union (re.union (str.to_re "0") (re.++ ((_ re.loop 1 1) (str.to_re "-")) (re.union (re.++ ((_ re.loop 1 1) (re.range "1" "9")) ((_ re.loop 0 1) (re.range "0" "9"))) (re.++ ((_ re.loop 1 1) (str.to_re "1")) (re.union (re.++ ((_ re.loop 1 1) (re.range "0" "1")) ((_ re.loop 1 1) (re.range "0" "9"))) (re.++ ((_ re.loop 1 1) (str.to_re "2")) ((_ re.loop 1 1) (re.range "0" "8")))))))) (re.++ (re.opt (str.to_re "+")) (re.union (re.++ ((_ re.loop 1 1) (re.range "1" "9")) ((_ re.loop 0 1) (re.range "0" "9"))) (re.++ ((_ re.loop 1 1) (str.to_re "1")) (re.union (re.++ ((_ re.loop 1 1) (re.range "0" "1")) ((_ re.loop 1 1) (re.range "0" "9"))) (re.++ ((_ re.loop 1 1) (str.to_re "2")) ((_ re.loop 1 1) (re.range "0" "7"))))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)