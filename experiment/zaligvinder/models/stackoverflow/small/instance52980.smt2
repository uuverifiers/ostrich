;test regex ^[0-9]{1,2}\.[mp4|mpg|avi]?
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "") (re.++ ((_ re.loop 1 2) (re.range "0" "9")) (re.++ (str.to_re ".") (re.opt (re.union (str.to_re "m") (re.union (str.to_re "p") (re.union (str.to_re "4") (re.union (str.to_re "|") (re.union (str.to_re "m") (re.union (str.to_re "p") (re.union (str.to_re "g") (re.union (str.to_re "|") (re.union (str.to_re "a") (re.union (str.to_re "v") (str.to_re "i")))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)