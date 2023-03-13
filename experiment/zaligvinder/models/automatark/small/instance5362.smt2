(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; Subject\u{3a}\s+OnlineServer\u{3a}Yeah\!User-Agent\u{3a}
(assert (str.in_re X (re.++ (str.to_re "Subject:") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "OnlineServer:Yeah!User-Agent:\u{0a}"))))
; ^0*(\d{1,3}(\.?\d{3})*)\-?([\dkK])$
(assert (not (str.in_re X (re.++ (re.* (str.to_re "0")) (re.opt (str.to_re "-")) (re.union (re.range "0" "9") (str.to_re "k") (str.to_re "K")) (str.to_re "\u{0a}") ((_ re.loop 1 3) (re.range "0" "9")) (re.* (re.++ (re.opt (str.to_re ".")) ((_ re.loop 3 3) (re.range "0" "9"))))))))
; Logger\w+searchreslt\dSubject\x3AHANDY\x2FrssScaner
(assert (not (str.in_re X (re.++ (str.to_re "Logger") (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "searchreslt") (re.range "0" "9") (str.to_re "Subject:HANDY/rssScaner\u{0a}")))))
; ^(0\.|([1-9]([0-9]+)?)\.){3}(0|([1-9]([0-9]+)?)){1}$
(assert (str.in_re X (re.++ ((_ re.loop 3 3) (re.union (str.to_re "0.") (re.++ (str.to_re ".") (re.range "1" "9") (re.opt (re.+ (re.range "0" "9")))))) ((_ re.loop 1 1) (re.union (str.to_re "0") (re.++ (re.range "1" "9") (re.opt (re.+ (re.range "0" "9")))))) (str.to_re "\u{0a}"))))
(check-sat)
