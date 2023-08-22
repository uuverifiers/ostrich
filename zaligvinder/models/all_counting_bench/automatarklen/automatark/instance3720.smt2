(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /\u{2e}f4v([\?\u{5c}\u{2f}]|$)/smiU
(assert (not (str.in_re X (re.++ (str.to_re "/.f4v") (re.union (str.to_re "?") (str.to_re "\u{5c}") (str.to_re "/")) (str.to_re "/smiU\u{0a}")))))
; asdbiz\x2Ebiz\s+HWAEUser-Agent\x3ATheef2
(assert (str.in_re X (re.++ (str.to_re "asdbiz.biz") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "HWAEUser-Agent:Theef2\u{0a}"))))
; (^\d{3,5}\,\d{2}$)|(^\d{3,5}$)
(assert (not (str.in_re X (re.union (re.++ ((_ re.loop 3 5) (re.range "0" "9")) (str.to_re ",") ((_ re.loop 2 2) (re.range "0" "9"))) (re.++ ((_ re.loop 3 5) (re.range "0" "9")) (str.to_re "\u{0a}"))))))
; client\x2Ebaigoo\x2EcomUser\x3A
(assert (not (str.in_re X (str.to_re "client.baigoo.comUser:\u{0a}"))))
; Host\x3A[^\n\r]*Travel[^\n\r]*From\x3Awww\x2EZSearchResults\x2Ecom
(assert (str.in_re X (re.++ (str.to_re "Host:") (re.* (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}"))) (str.to_re "Travel") (re.* (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}"))) (str.to_re "From:www.ZSearchResults.com\u{13}\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
