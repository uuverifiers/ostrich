(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; offers\x2Ebullseye-network\x2Ecom\s+news[^\n\r]*WatcherUser-Agent\x3A
(assert (str.in_re X (re.++ (str.to_re "offers.bullseye-network.com") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "news") (re.* (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}"))) (str.to_re "WatcherUser-Agent:\u{0a}"))))
; (^\d{9}[V|v|x|X]$)
(assert (str.in_re X (re.++ (str.to_re "\u{0a}") ((_ re.loop 9 9) (re.range "0" "9")) (re.union (str.to_re "V") (str.to_re "|") (str.to_re "v") (str.to_re "x") (str.to_re "X")))))
; .*[Oo0][Ee][Mm].*
(assert (str.in_re X (re.++ (re.* re.allchar) (re.union (str.to_re "O") (str.to_re "o") (str.to_re "0")) (re.union (str.to_re "E") (str.to_re "e")) (re.union (str.to_re "M") (str.to_re "m")) (re.* re.allchar) (str.to_re "\u{0a}"))))
; Kontiki\s+resultsmaster\x2Ecom\u{7c}roogoo\u{7c}
(assert (str.in_re X (re.++ (str.to_re "Kontiki") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "resultsmaster.com\u{13}|roogoo|\u{0a}"))))
; body=\u{25}21\u{25}21\u{25}21Optix\s+Host\u{3a}
(assert (not (str.in_re X (re.++ (str.to_re "body=%21%21%21Optix\u{13}") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "Host:\u{0a}")))))
(check-sat)
