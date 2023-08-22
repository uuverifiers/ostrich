(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; Host\x3A.*client\x2Ebaigoo\x2Ecom
(assert (not (str.in_re X (re.++ (str.to_re "Host:") (re.* re.allchar) (str.to_re "client.baigoo.com\u{0a}")))))
; /\u{2e}s3m([\?\u{5c}\u{2f}]|$)/smiU
(assert (not (str.in_re X (re.++ (str.to_re "/.s3m") (re.union (str.to_re "?") (str.to_re "\u{5c}") (str.to_re "/")) (str.to_re "/smiU\u{0a}")))))
; ^([012346789][0-9]{4})$
(assert (str.in_re X (re.++ (str.to_re "\u{0a}") (re.union (str.to_re "0") (str.to_re "1") (str.to_re "2") (str.to_re "3") (str.to_re "4") (str.to_re "6") (str.to_re "7") (str.to_re "8") (str.to_re "9")) ((_ re.loop 4 4) (re.range "0" "9")))))
; <([^\s>]*)(\s[^<]*)>
(assert (not (str.in_re X (re.++ (str.to_re "<") (re.* (re.union (str.to_re ">") (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re ">\u{0a}") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (re.* (re.comp (str.to_re "<")))))))
(assert (> (str.len X) 10))
(check-sat)
