;test regex (?:<p>[^<]+<\/p>\r?\n){5}\K(?:<p>[^<]+<\/p>\r?\n){1,2}((?:<p>[^<]+<\/p>\r?\n)*)
(declare-const X String)
(assert (str.in_re X (re.++ ((_ re.loop 5 5) (re.++ (str.to_re "<") (re.++ (str.to_re "p") (re.++ (str.to_re ">") (re.++ (re.+ (re.diff re.allchar (str.to_re "<"))) (re.++ (str.to_re "<") (re.++ (str.to_re "/") (re.++ (str.to_re "p") (re.++ (str.to_re ">") (re.++ (re.opt (str.to_re "\u{0d}")) (str.to_re "\u{0a}"))))))))))) (re.++ (str.to_re "K") (re.++ ((_ re.loop 1 2) (re.++ (str.to_re "<") (re.++ (str.to_re "p") (re.++ (str.to_re ">") (re.++ (re.+ (re.diff re.allchar (str.to_re "<"))) (re.++ (str.to_re "<") (re.++ (str.to_re "/") (re.++ (str.to_re "p") (re.++ (str.to_re ">") (re.++ (re.opt (str.to_re "\u{0d}")) (str.to_re "\u{0a}"))))))))))) (re.* (re.++ (str.to_re "<") (re.++ (str.to_re "p") (re.++ (str.to_re ">") (re.++ (re.+ (re.diff re.allchar (str.to_re "<"))) (re.++ (str.to_re "<") (re.++ (str.to_re "/") (re.++ (str.to_re "p") (re.++ (str.to_re ">") (re.++ (re.opt (str.to_re "\u{0d}")) (str.to_re "\u{0a}"))))))))))))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)