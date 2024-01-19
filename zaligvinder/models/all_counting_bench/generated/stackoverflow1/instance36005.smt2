;test regex ^[cs|ch|es|ee|it|me]{2}$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") ((_ re.loop 2 2) (re.union (str.to_re "c") (re.union (str.to_re "s") (re.union (str.to_re "|") (re.union (str.to_re "c") (re.union (str.to_re "h") (re.union (str.to_re "|") (re.union (str.to_re "e") (re.union (str.to_re "s") (re.union (str.to_re "|") (re.union (str.to_re "e") (re.union (str.to_re "e") (re.union (str.to_re "|") (re.union (str.to_re "i") (re.union (str.to_re "t") (re.union (str.to_re "|") (re.union (str.to_re "m") (str.to_re "e"))))))))))))))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)