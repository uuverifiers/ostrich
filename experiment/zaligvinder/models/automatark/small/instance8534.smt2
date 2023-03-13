(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; User.*User-Agent\x3A.*ResultATTENTION\x3Ariggiymd\u{2f}wdhi\.vhi
(assert (str.in_re X (re.++ (str.to_re "User") (re.* re.allchar) (str.to_re "User-Agent:") (re.* re.allchar) (str.to_re "ResultATTENTION:riggiymd/wdhi.vhi\u{0a}"))))
; ^([0-9]{0,5}|[0-9]{0,5}\.[0-9]{0,3})$
(assert (not (str.in_re X (re.++ (re.union ((_ re.loop 0 5) (re.range "0" "9")) (re.++ ((_ re.loop 0 5) (re.range "0" "9")) (str.to_re ".") ((_ re.loop 0 3) (re.range "0" "9")))) (str.to_re "\u{0a}")))))
; BysooTBUser-Agent\x3A
(assert (str.in_re X (str.to_re "BysooTBUser-Agent:\u{0a}")))
; toolbarplace\x2Ecom[^\n\r]*Server[^\n\r]*X-Mailer\u{3a}\sUser-Agent\u{3a}Host\x3ABar\x2Fnewsurfer4\x2F
(assert (not (str.in_re X (re.++ (str.to_re "toolbarplace.com") (re.* (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}"))) (str.to_re "Server") (re.* (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}"))) (str.to_re "X-Mailer:\u{13}") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "User-Agent:Host:Bar/newsurfer4/\u{0a}")))))
(check-sat)
