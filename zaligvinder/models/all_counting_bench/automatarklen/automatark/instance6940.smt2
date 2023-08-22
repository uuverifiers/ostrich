(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; Host\x3A\s+www\x2Einternet-optimizer\x2EcomToolBarKeylogger
(assert (not (str.in_re X (re.++ (str.to_re "Host:") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "www.internet-optimizer.comToolBarKeylogger\u{0a}")))))
; ([^\w]+)|([^A-Za-z])|(\b[^aeiouy]+\b)|(\b(\w{2})\b)
(assert (not (str.in_re X (re.union (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (re.+ (re.union (str.to_re "a") (str.to_re "e") (str.to_re "i") (str.to_re "o") (str.to_re "u") (str.to_re "y"))) (re.++ ((_ re.loop 2 2) (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "\u{0a}")) (re.range "A" "Z") (re.range "a" "z")))))
; sidesearch\.dropspam\.com\s+Strip-Player
(assert (str.in_re X (re.++ (str.to_re "sidesearch.dropspam.com") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "Strip-Player\u{1b}\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
