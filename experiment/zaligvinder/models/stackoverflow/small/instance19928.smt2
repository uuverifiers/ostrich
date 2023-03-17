;test regex '[A|C|T|G]{4}'
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "\u{27}") (re.++ ((_ re.loop 4 4) (re.union (str.to_re "A") (re.union (str.to_re "|") (re.union (str.to_re "C") (re.union (str.to_re "|") (re.union (str.to_re "T") (re.union (str.to_re "|") (str.to_re "G")))))))) (str.to_re "\u{27}")))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)