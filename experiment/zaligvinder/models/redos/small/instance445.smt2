;test regex NEED_PASSPHRASE (.{16}) (.{16}).*\n
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "N") (re.++ (str.to_re "E") (re.++ (str.to_re "E") (re.++ (str.to_re "D") (re.++ (str.to_re "_") (re.++ (str.to_re "P") (re.++ (str.to_re "A") (re.++ (str.to_re "S") (re.++ (str.to_re "S") (re.++ (str.to_re "P") (re.++ (str.to_re "H") (re.++ (str.to_re "R") (re.++ (str.to_re "A") (re.++ (str.to_re "S") (re.++ (str.to_re "E") (re.++ (str.to_re " ") (re.++ ((_ re.loop 16 16) (re.diff re.allchar (str.to_re "\n"))) (re.++ (str.to_re " ") (re.++ ((_ re.loop 16 16) (re.diff re.allchar (str.to_re "\n"))) (re.++ (re.* (re.diff re.allchar (str.to_re "\n"))) (str.to_re "\u{0a}")))))))))))))))))))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)