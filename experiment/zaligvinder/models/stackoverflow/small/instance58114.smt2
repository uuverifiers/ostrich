;test regex SUBSTRING(delayed_jobs.handler, ':(\\w+){1}\\n')
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "S") (re.++ (str.to_re "U") (re.++ (str.to_re "B") (re.++ (str.to_re "S") (re.++ (str.to_re "T") (re.++ (str.to_re "R") (re.++ (str.to_re "I") (re.++ (str.to_re "N") (re.++ (str.to_re "G") (re.++ (re.++ (str.to_re "d") (re.++ (str.to_re "e") (re.++ (str.to_re "l") (re.++ (str.to_re "a") (re.++ (str.to_re "y") (re.++ (str.to_re "e") (re.++ (str.to_re "d") (re.++ (str.to_re "_") (re.++ (str.to_re "j") (re.++ (str.to_re "o") (re.++ (str.to_re "b") (re.++ (str.to_re "s") (re.++ (re.diff re.allchar (str.to_re "\n")) (re.++ (str.to_re "h") (re.++ (str.to_re "a") (re.++ (str.to_re "n") (re.++ (str.to_re "d") (re.++ (str.to_re "l") (re.++ (str.to_re "e") (str.to_re "r")))))))))))))))))))) (re.++ (str.to_re ",") (re.++ (str.to_re " ") (re.++ (str.to_re "\u{27}") (re.++ (str.to_re ":") (re.++ ((_ re.loop 1 1) (re.++ (str.to_re "\\") (re.+ (str.to_re "w")))) (re.++ (str.to_re "\\") (re.++ (str.to_re "n") (str.to_re "\u{27}"))))))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)