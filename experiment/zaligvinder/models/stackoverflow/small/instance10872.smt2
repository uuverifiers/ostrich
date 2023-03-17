;test regex params: '^\\r\\-\\d{6}\\-\\d{3}$|^\\R\\-\\d{6}\\-\\d{3}$'
(declare-const X String)
(assert (str.in_re X (re.union (re.++ (re.++ (re.++ (str.to_re "p") (re.++ (str.to_re "a") (re.++ (str.to_re "r") (re.++ (str.to_re "a") (re.++ (str.to_re "m") (re.++ (str.to_re "s") (re.++ (str.to_re ":") (re.++ (str.to_re " ") (str.to_re "\u{27}"))))))))) (re.++ (str.to_re "") (re.++ (str.to_re "\\") (re.++ (str.to_re "r") (re.++ (str.to_re "\\") (re.++ (str.to_re "-") (re.++ (str.to_re "\\") (re.++ ((_ re.loop 6 6) (str.to_re "d")) (re.++ (str.to_re "\\") (re.++ (str.to_re "-") (re.++ (str.to_re "\\") ((_ re.loop 3 3) (str.to_re "d"))))))))))))) (str.to_re "")) (re.++ (re.++ (str.to_re "") (re.++ (str.to_re "\\") (re.++ (str.to_re "R") (re.++ (str.to_re "\\") (re.++ (str.to_re "-") (re.++ (str.to_re "\\") (re.++ ((_ re.loop 6 6) (str.to_re "d")) (re.++ (str.to_re "\\") (re.++ (str.to_re "-") (re.++ (str.to_re "\\") ((_ re.loop 3 3) (str.to_re "d")))))))))))) (re.++ (str.to_re "") (str.to_re "\u{27}"))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)