(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /\u{2e}appendChild.*?\u{2e}id.{0,200}?(offset|client)(Height|Left|Parent|Top|Width).{0,200}?(offset|client)(Height|Left|Parent|Top|Width)/is
(assert (str.in_re X (re.++ (str.to_re "/.appendChild") (re.* re.allchar) (str.to_re ".id") ((_ re.loop 0 200) re.allchar) (re.union (str.to_re "offset") (str.to_re "client")) (re.union (str.to_re "Height") (str.to_re "Left") (str.to_re "Parent") (str.to_re "Top") (str.to_re "Width")) ((_ re.loop 0 200) re.allchar) (re.union (str.to_re "offset") (str.to_re "client")) (re.union (str.to_re "Height") (str.to_re "Left") (str.to_re "Parent") (str.to_re "Top") (str.to_re "Width")) (str.to_re "/is\u{0a}"))))
; pjpoptwql\u{2f}rlnjsportsHost\x3ASubject\u{3a}YAHOOdestroyed\u{21}
(assert (not (str.in_re X (str.to_re "pjpoptwql/rlnjsportsHost:Subject:YAHOOdestroyed!\u{0a}"))))
; Host\x3A.*c=[^\n\r]*KeyloggerHost\x3Awww\.trackhits\.cc
(assert (not (str.in_re X (re.++ (str.to_re "Host:") (re.* re.allchar) (str.to_re "c=") (re.* (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}"))) (str.to_re "KeyloggerHost:www.trackhits.cc\u{0a}")))))
; (^(09|9)[1][1-9]\\d{7}$)|(^(09|9)[3][12456]\\d{7}$)
(assert (str.in_re X (re.union (re.++ (re.union (str.to_re "09") (str.to_re "9")) (str.to_re "1") (re.range "1" "9") (str.to_re "\u{5c}") ((_ re.loop 7 7) (str.to_re "d"))) (re.++ (str.to_re "\u{0a}") (re.union (str.to_re "09") (str.to_re "9")) (str.to_re "3") (re.union (str.to_re "1") (str.to_re "2") (str.to_re "4") (str.to_re "5") (str.to_re "6")) (str.to_re "\u{5c}") ((_ re.loop 7 7) (str.to_re "d"))))))
(check-sat)
