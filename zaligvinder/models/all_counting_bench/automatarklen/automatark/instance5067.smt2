(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /\x3F[0-9a-z]{32}D/U
(assert (not (str.in_re X (re.++ (str.to_re "/?") ((_ re.loop 32 32) (re.union (re.range "0" "9") (re.range "a" "z"))) (str.to_re "D/U\u{0a}")))))
; url=http\x3AGamespyjspIDENTIFYserverHOST\x3ASubject\x3A
(assert (not (str.in_re X (str.to_re "url=http:\u{1b}GamespyjspIDENTIFYserverHOST:Subject:\u{0a}"))))
; Toolbar\d+Host\x3AWelcome\x2FcommunicatortbGateCrasher
(assert (not (str.in_re X (re.++ (str.to_re "Toolbar") (re.+ (re.range "0" "9")) (str.to_re "Host:Welcome/communicatortbGateCrasher\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
