(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; Host\x3A\d+Subject\x3A[^\n\r]*Seconds\-ovplHost\x3AHost\x3ADownload
(assert (not (str.in_re X (re.++ (str.to_re "Host:") (re.+ (re.range "0" "9")) (str.to_re "Subject:") (re.* (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}"))) (str.to_re "Seconds-ovplHost:Host:Download\u{0a}")))))
; /^\u{01}\u{02}.{0,50}[a-zA-Z]{10}\u{2f}PK.{0,50}[a-zA-Z]{10}\u{2f}[a-zA-Z]{7}\.classPK/sR
(assert (not (str.in_re X (re.++ (str.to_re "/\u{01}\u{02}") ((_ re.loop 0 50) re.allchar) ((_ re.loop 10 10) (re.union (re.range "a" "z") (re.range "A" "Z"))) (str.to_re "/PK") ((_ re.loop 0 50) re.allchar) ((_ re.loop 10 10) (re.union (re.range "a" "z") (re.range "A" "Z"))) (str.to_re "/") ((_ re.loop 7 7) (re.union (re.range "a" "z") (re.range "A" "Z"))) (str.to_re ".classPK/sR\u{0a}")))))
; Yeah\!Host\x3AEnTrYwww\x2EZSearchResults\x2Ecom
(assert (not (str.in_re X (str.to_re "Yeah!Host:EnTrYwww.ZSearchResults.com\u{13}\u{0a}"))))
; User-Agent\x3A[^\n\r]*Host\x3A.*\x2Ftoolbar\x2FHost\x3AUser-Agent\x3A
(assert (not (str.in_re X (re.++ (str.to_re "User-Agent:") (re.* (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}"))) (str.to_re "Host:") (re.* re.allchar) (str.to_re "/toolbar/Host:User-Agent:\u{0a}")))))
(check-sat)
