;test regex ((11)+0|(00)+1|(10|01|(11)+10|(00)+01)[10])([10]{2})*
(declare-const X String)
(assert (str.in_re X (re.++ (re.union (re.union (re.++ (re.+ (str.to_re "11")) (str.to_re "0")) (re.++ (re.+ (str.to_re "00")) (str.to_re "1"))) (re.++ (re.union (re.union (re.union (str.to_re "10") (str.to_re "01")) (re.++ (re.+ (str.to_re "11")) (str.to_re "10"))) (re.++ (re.+ (str.to_re "00")) (str.to_re "01"))) (str.to_re "10"))) (re.* ((_ re.loop 2 2) (str.to_re "10"))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)