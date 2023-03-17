;test regex ([1-9]{1,2})?(d|D)([1-9]{1,3})((\+|-)([1-9]{1,3}))?
(declare-const X String)
(assert (str.in_re X (re.++ (re.opt ((_ re.loop 1 2) (re.range "1" "9"))) (re.++ (re.union (str.to_re "d") (str.to_re "D")) (re.++ ((_ re.loop 1 3) (re.range "1" "9")) (re.opt (re.++ (re.union (str.to_re "+") (str.to_re "-")) ((_ re.loop 1 3) (re.range "1" "9")))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)