;test regex REGEX_PATTERN = @"^out_\d{6}(?:_.{1,150})?$";
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (re.++ (str.to_re "R") (re.++ (str.to_re "E") (re.++ (str.to_re "G") (re.++ (str.to_re "E") (re.++ (str.to_re "X") (re.++ (str.to_re "_") (re.++ (str.to_re "P") (re.++ (str.to_re "A") (re.++ (str.to_re "T") (re.++ (str.to_re "T") (re.++ (str.to_re "E") (re.++ (str.to_re "R") (re.++ (str.to_re "N") (re.++ (str.to_re " ") (re.++ (str.to_re "=") (re.++ (str.to_re " ") (re.++ (str.to_re "@") (str.to_re "\u{22}")))))))))))))))))) (re.++ (str.to_re "") (re.++ (str.to_re "o") (re.++ (str.to_re "u") (re.++ (str.to_re "t") (re.++ (str.to_re "_") (re.++ ((_ re.loop 6 6) (re.range "0" "9")) (re.opt (re.++ (str.to_re "_") ((_ re.loop 1 150) (re.diff re.allchar (str.to_re "\n")))))))))))) (re.++ (str.to_re "") (re.++ (str.to_re "\u{22}") (str.to_re ";"))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 200 (str.len X)))
(check-sat)
(get-model)