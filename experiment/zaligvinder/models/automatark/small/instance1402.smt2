(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; Mirar_KeywordContent
(assert (str.in_re X (str.to_re "Mirar_KeywordContent\u{13}\u{0a}")))
; Host\u{3a}notificationwww\.thecommunicator\.net
(assert (not (str.in_re X (str.to_re "Host:notification\u{13}www.thecommunicator.net\u{0a}"))))
; /\u{2e}cnt([\?\u{5c}\u{2f}]|$)/smiU
(assert (not (str.in_re X (re.++ (str.to_re "/.cnt") (re.union (str.to_re "?") (str.to_re "\u{5c}") (str.to_re "/")) (str.to_re "/smiU\u{0a}")))))
; (\d{3}\-\d{2}\-\d{4})
(assert (str.in_re X (re.++ (str.to_re "\u{0a}") ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 4 4) (re.range "0" "9")))))
(check-sat)
