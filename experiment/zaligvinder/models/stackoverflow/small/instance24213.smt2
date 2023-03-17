;test regex "([\\w ]+)(?:(\\d{4})(?:\\s*(?:720|480|1080)[pP])?)?"
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "\u{22}") (re.++ (re.+ (re.union (str.to_re "\\") (re.union (str.to_re "w") (str.to_re " ")))) (re.++ (re.opt (re.++ (re.++ (str.to_re "\\") ((_ re.loop 4 4) (str.to_re "d"))) (re.opt (re.++ (str.to_re "\\") (re.++ (re.* (str.to_re "s")) (re.++ (re.union (re.union (str.to_re "720") (str.to_re "480")) (str.to_re "1080")) (re.union (str.to_re "p") (str.to_re "P")))))))) (str.to_re "\u{22}"))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)