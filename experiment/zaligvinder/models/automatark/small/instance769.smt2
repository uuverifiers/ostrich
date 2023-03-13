(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; Version\s+User-Agent\x3Abindmqnqgijmng\u{2f}oj
(assert (str.in_re X (re.++ (str.to_re "Version") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "User-Agent:bindmqnqgijmng/oj\u{0a}"))))
; ([0-9]{6}|[0-9]{3}\s[0-9]{3})
(assert (str.in_re X (re.++ (re.union ((_ re.loop 6 6) (re.range "0" "9")) (re.++ ((_ re.loop 3 3) (re.range "0" "9")) (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) ((_ re.loop 3 3) (re.range "0" "9")))) (str.to_re "\u{0a}"))))
; ^\d{1,2}\.\d{3}\.\d{3}[-][0-9kK]{1}$
(assert (str.in_re X (re.++ ((_ re.loop 1 2) (re.range "0" "9")) (str.to_re ".") ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re ".") ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 1 1) (re.union (re.range "0" "9") (str.to_re "k") (str.to_re "K"))) (str.to_re "\u{0a}"))))
; User-Agent\x3A\s+GETwww\x2Eoemji\x2Ecom
(assert (str.in_re X (re.++ (str.to_re "User-Agent:") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "GETwww.oemji.com\u{0a}"))))
; toolbarplace\x2Ecom[^\n\r]*Server[^\n\r]*X-Mailer\u{3a}\sUser-Agent\u{3a}Host\x3ABar\x2Fnewsurfer4\x2F
(assert (str.in_re X (re.++ (str.to_re "toolbarplace.com") (re.* (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}"))) (str.to_re "Server") (re.* (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}"))) (str.to_re "X-Mailer:\u{13}") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "User-Agent:Host:Bar/newsurfer4/\u{0a}"))))
(check-sat)
