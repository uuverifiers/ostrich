(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; Toolbar[^\n\r]*url=\d+Host\x3AWelcome\x2FcommunicatortbGateCrasher
(assert (str.in_re X (re.++ (str.to_re "Toolbar") (re.* (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}"))) (str.to_re "url=") (re.+ (re.range "0" "9")) (str.to_re "Host:Welcome/communicatortbGateCrasher\u{0a}"))))
; www\.thecommunicator\.net\sHost\x3A\dhoroscope2
(assert (not (str.in_re X (re.++ (str.to_re "www.thecommunicator.net") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "Host:") (re.range "0" "9") (str.to_re "horoscope2\u{0a}")))))
; [A-Za-z]{2}[0-9]{1,6}|[0-9]{1,8}
(assert (not (str.in_re X (re.union (re.++ ((_ re.loop 2 2) (re.union (re.range "A" "Z") (re.range "a" "z"))) ((_ re.loop 1 6) (re.range "0" "9"))) (re.++ ((_ re.loop 1 8) (re.range "0" "9")) (str.to_re "\u{0a}"))))))
; (:(6553[0-5]|655[0-2][0-9]\d|65[0-4](\d){2}|6[0-4](\d){3}|[1-5](\d){4}|[1-9](\d){0,3}))?
(assert (str.in_re X (re.++ (re.opt (re.++ (str.to_re ":") (re.union (re.++ (str.to_re "6553") (re.range "0" "5")) (re.++ (str.to_re "655") (re.range "0" "2") (re.range "0" "9") (re.range "0" "9")) (re.++ (str.to_re "65") (re.range "0" "4") ((_ re.loop 2 2) (re.range "0" "9"))) (re.++ (str.to_re "6") (re.range "0" "4") ((_ re.loop 3 3) (re.range "0" "9"))) (re.++ (re.range "1" "5") ((_ re.loop 4 4) (re.range "0" "9"))) (re.++ (re.range "1" "9") ((_ re.loop 0 3) (re.range "0" "9")))))) (str.to_re "\u{0a}"))))
; [a-z0-9]{1,11}
(assert (not (str.in_re X (re.++ ((_ re.loop 1 11) (re.union (re.range "a" "z") (re.range "0" "9"))) (str.to_re "\u{0a}")))))
(check-sat)
