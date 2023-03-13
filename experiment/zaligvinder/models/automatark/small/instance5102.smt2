(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; \b\w+\b
(assert (not (str.in_re X (re.++ (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "\u{0a}")))))
; ^\d{2,6}-\d{2}-\d$
(assert (str.in_re X (re.++ ((_ re.loop 2 6) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re "-") (re.range "0" "9") (str.to_re "\u{0a}"))))
; User-Agent\x3A.*Host\u{3a}\s+www\x2Ewordiq\x2Ecom\s+Subject\x3AAlexaOnline\u{25}21\u{25}21\u{25}21
(assert (not (str.in_re X (re.++ (str.to_re "User-Agent:") (re.* re.allchar) (str.to_re "Host:") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "www.wordiq.com\u{1b}") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "Subject:AlexaOnline%21%21%21\u{0a}")))))
; RequestWindowszzzvmkituktgr\u{2f}etieencoder
(assert (not (str.in_re X (str.to_re "RequestWindowszzzvmkituktgr/etieencoder\u{0a}"))))
(check-sat)
