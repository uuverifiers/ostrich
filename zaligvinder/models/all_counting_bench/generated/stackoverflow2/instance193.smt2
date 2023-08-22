;test regex <p.{0,80}##START_ACT##.*?</p>
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "<") (re.++ (str.to_re "p") (re.++ ((_ re.loop 0 80) (re.diff re.allchar (str.to_re "\n"))) (re.++ (str.to_re "#") (re.++ (str.to_re "#") (re.++ (str.to_re "S") (re.++ (str.to_re "T") (re.++ (str.to_re "A") (re.++ (str.to_re "R") (re.++ (str.to_re "T") (re.++ (str.to_re "_") (re.++ (str.to_re "A") (re.++ (str.to_re "C") (re.++ (str.to_re "T") (re.++ (str.to_re "#") (re.++ (str.to_re "#") (re.++ (re.* (re.diff re.allchar (str.to_re "\n"))) (re.++ (str.to_re "<") (re.++ (str.to_re "/") (re.++ (str.to_re "p") (str.to_re ">")))))))))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)