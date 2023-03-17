;test regex ^(.{2,250}) ([0-9]{4,10}) ([^,]{2,80}) *(,.+)?$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ ((_ re.loop 2 250) (re.diff re.allchar (str.to_re "\n"))) (re.++ (str.to_re " ") (re.++ ((_ re.loop 4 10) (re.range "0" "9")) (re.++ (str.to_re " ") (re.++ ((_ re.loop 2 80) (re.diff re.allchar (str.to_re ","))) (re.++ (re.* (str.to_re " ")) (re.opt (re.++ (str.to_re ",") (re.+ (re.diff re.allchar (str.to_re "\n")))))))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 50 (str.len X)))
(check-sat)
(get-model)