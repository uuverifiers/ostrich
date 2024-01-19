(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; \d+\s*[.'-]\s*\d+\s*[\d+.m\"]*
(assert (str.in_re X (re.++ (re.+ (re.range "0" "9")) (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.union (str.to_re ".") (str.to_re "'") (str.to_re "-")) (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.+ (re.range "0" "9")) (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.* (re.union (re.range "0" "9") (str.to_re "+") (str.to_re ".") (str.to_re "m") (str.to_re "\u{22}"))) (str.to_re "\u{0a}"))))
; /\x2Fmrow\x5Fpin\x2F\x3Fid\d+[a-z]{5,}\d{5}\u{26}rnd\x3D\d+/smi
(assert (not (str.in_re X (re.++ (str.to_re "//mrow_pin/?id") (re.+ (re.range "0" "9")) ((_ re.loop 5 5) (re.range "0" "9")) (str.to_re "&rnd=") (re.+ (re.range "0" "9")) (str.to_re "/smi\u{0a}") ((_ re.loop 5 5) (re.range "a" "z")) (re.* (re.range "a" "z"))))))
; ^0*(\d{1,3}(\.?\d{3})*)\-?([\dkK])$
(assert (not (str.in_re X (re.++ (re.* (str.to_re "0")) (re.opt (str.to_re "-")) (re.union (re.range "0" "9") (str.to_re "k") (str.to_re "K")) (str.to_re "\u{0a}") ((_ re.loop 1 3) (re.range "0" "9")) (re.* (re.++ (re.opt (str.to_re ".")) ((_ re.loop 3 3) (re.range "0" "9"))))))))
; User-Agent\x3A.*Host\u{3a}\s+www\x2Ewordiq\x2Ecom\s+Subject\x3AAlexaOnline\u{25}21\u{25}21\u{25}21
(assert (not (str.in_re X (re.++ (str.to_re "User-Agent:") (re.* re.allchar) (str.to_re "Host:") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "www.wordiq.com\u{1b}") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "Subject:AlexaOnline%21%21%21\u{0a}")))))
; Google\s+-~-GREATHost\u{3a}FILESIZE\x3E
(assert (not (str.in_re X (re.++ (str.to_re "Google") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "-~-GREATHost:FILESIZE>\u{13}\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
