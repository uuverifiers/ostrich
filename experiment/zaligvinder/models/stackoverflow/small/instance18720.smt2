;test regex [MTM|SIR|FDF|TAA]{3}
(declare-const X String)
(assert (str.in_re X ((_ re.loop 3 3) (re.union (str.to_re "M") (re.union (str.to_re "T") (re.union (str.to_re "M") (re.union (str.to_re "|") (re.union (str.to_re "S") (re.union (str.to_re "I") (re.union (str.to_re "R") (re.union (str.to_re "|") (re.union (str.to_re "F") (re.union (str.to_re "D") (re.union (str.to_re "F") (re.union (str.to_re "|") (re.union (str.to_re "T") (re.union (str.to_re "A") (str.to_re "A"))))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)