(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /\?id=[A-Z0-9]{20}&cmd=img/U
(assert (str.in_re X (re.++ (str.to_re "/?id=") ((_ re.loop 20 20) (re.union (re.range "A" "Z") (re.range "0" "9"))) (str.to_re "&cmd=img/U\u{0a}"))))
; Word\s+User-Agent\u{3a}www\x2Esogou\x2Ecom
(assert (not (str.in_re X (re.++ (str.to_re "Word") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "User-Agent:www.sogou.com\u{0a}")))))
; \x5D\u{25}20\x5BPort_\d+TM_SEARCH3engineto=\x2Fezsb\s\x3A
(assert (not (str.in_re X (re.++ (str.to_re "]%20[Port_") (re.+ (re.range "0" "9")) (str.to_re "TM_SEARCH3engineto=/ezsb") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re ":\u{0a}")))))
; Toolbar[^\n\r]*url=\d+Host\x3AWelcome\x2FcommunicatortbGateCrasher
(assert (str.in_re X (re.++ (str.to_re "Toolbar") (re.* (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}"))) (str.to_re "url=") (re.+ (re.range "0" "9")) (str.to_re "Host:Welcome/communicatortbGateCrasher\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
