;test regex s/^APP_[^_]{3}_[^_]{3}_(?:LOG|CFC)_(.+)_\d[WMD](?:_\d+)?$/$1/;
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (re.++ (re.++ (str.to_re "s") (str.to_re "/")) (re.++ (str.to_re "") (re.++ (str.to_re "A") (re.++ (str.to_re "P") (re.++ (str.to_re "P") (re.++ (str.to_re "_") (re.++ ((_ re.loop 3 3) (re.diff re.allchar (str.to_re "_"))) (re.++ (str.to_re "_") (re.++ ((_ re.loop 3 3) (re.diff re.allchar (str.to_re "_"))) (re.++ (str.to_re "_") (re.++ (re.union (re.++ (str.to_re "L") (re.++ (str.to_re "O") (str.to_re "G"))) (re.++ (str.to_re "C") (re.++ (str.to_re "F") (str.to_re "C")))) (re.++ (str.to_re "_") (re.++ (re.+ (re.diff re.allchar (str.to_re "\n"))) (re.++ (str.to_re "_") (re.++ (re.range "0" "9") (re.++ (re.union (str.to_re "W") (re.union (str.to_re "M") (str.to_re "D"))) (re.opt (re.++ (str.to_re "_") (re.+ (re.range "0" "9")))))))))))))))))))) (re.++ (str.to_re "") (str.to_re "/"))) (re.++ (str.to_re "") (re.++ (str.to_re "1") (re.++ (str.to_re "/") (str.to_re ";")))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)