(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /\u{2e}csv([\?\u{5c}\u{2f}]|$)/smiU
(assert (not (str.in_re X (re.++ (str.to_re "/.csv") (re.union (str.to_re "?") (str.to_re "\u{5c}") (str.to_re "/")) (str.to_re "/smiU\u{0a}")))))
; (\"http:\/\/video\.google\.com\/googleplayer\.swf\?docId=\d{19}\&hl=[a-z]{2}\")
(assert (str.in_re X (re.++ (str.to_re "\u{0a}\u{22}http://video.google.com/googleplayer.swf?docId=") ((_ re.loop 19 19) (re.range "0" "9")) (str.to_re "&hl=") ((_ re.loop 2 2) (re.range "a" "z")) (str.to_re "\u{22}"))))
; ^[2-9]\d{2}-\d{3}-\d{4}$
(assert (not (str.in_re X (re.++ (re.range "2" "9") ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re "\u{0a}")))))
; User-Agent\x3A.*Host\u{3a}\s+www\x2Ewordiq\x2Ecom\s+Subject\x3AAlexaOnline\u{25}21\u{25}21\u{25}21
(assert (str.in_re X (re.++ (str.to_re "User-Agent:") (re.* re.allchar) (str.to_re "Host:") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "www.wordiq.com\u{1b}") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "Subject:AlexaOnline%21%21%21\u{0a}"))))
(check-sat)
