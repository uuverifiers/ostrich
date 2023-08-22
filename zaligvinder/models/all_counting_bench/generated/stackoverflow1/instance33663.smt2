;test regex '~^(\h*Data_\d{2,}:\h*")(.*)"~m'
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "\u{27}") (str.to_re "~")) (re.++ (str.to_re "") (re.++ (re.++ (re.* (str.to_re "h")) (re.++ (str.to_re "D") (re.++ (str.to_re "a") (re.++ (str.to_re "t") (re.++ (str.to_re "a") (re.++ (str.to_re "_") (re.++ (re.++ (re.* (re.range "0" "9")) ((_ re.loop 2 2) (re.range "0" "9"))) (re.++ (str.to_re ":") (re.++ (re.* (str.to_re "h")) (str.to_re "\u{22}")))))))))) (re.++ (re.* (re.diff re.allchar (str.to_re "\n"))) (re.++ (str.to_re "\u{22}") (re.++ (str.to_re "~") (re.++ (str.to_re "m") (str.to_re "\u{27}"))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)