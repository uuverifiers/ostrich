(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; SI\|Server\|\d+informationWinInetEvilFTPOSSProxy\x5Chome\/lordofsearch
(assert (str.in_re X (re.++ (str.to_re "SI|Server|\u{13}") (re.+ (re.range "0" "9")) (str.to_re "informationWinInetEvilFTPOSSProxy\u{5c}home/lordofsearch\u{0a}"))))
; ^\d{0,2}(\.\d{1,4})? *%?$
(assert (str.in_re X (re.++ ((_ re.loop 0 2) (re.range "0" "9")) (re.opt (re.++ (str.to_re ".") ((_ re.loop 1 4) (re.range "0" "9")))) (re.* (str.to_re " ")) (re.opt (str.to_re "%")) (str.to_re "\u{0a}"))))
; Server\.exeHWPEServer\u{3a}Host\x3A
(assert (str.in_re X (str.to_re "Server.exeHWPEServer:Host:\u{0a}")))
(assert (> (str.len X) 10))
(check-sat)
