;test regex \\d{1,3}\\.\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}\\s{1,10}\\d{1,4}\\sms.*
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "\\") (re.++ ((_ re.loop 1 3) (str.to_re "d")) (re.++ (str.to_re "\\") (re.++ (re.diff re.allchar (str.to_re "\n")) (re.++ (str.to_re "\\") (re.++ ((_ re.loop 1 3) (str.to_re "d")) (re.++ (str.to_re "\\") (re.++ (re.diff re.allchar (str.to_re "\n")) (re.++ (str.to_re "\\") (re.++ ((_ re.loop 1 3) (str.to_re "d")) (re.++ (str.to_re "\\") (re.++ (re.diff re.allchar (str.to_re "\n")) (re.++ (str.to_re "\\") (re.++ ((_ re.loop 1 3) (str.to_re "d")) (re.++ (str.to_re "\\") (re.++ ((_ re.loop 1 10) (str.to_re "s")) (re.++ (str.to_re "\\") (re.++ ((_ re.loop 1 4) (str.to_re "d")) (re.++ (str.to_re "\\") (re.++ (str.to_re "s") (re.++ (str.to_re "m") (re.++ (str.to_re "s") (re.* (re.diff re.allchar (str.to_re "\n")))))))))))))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)