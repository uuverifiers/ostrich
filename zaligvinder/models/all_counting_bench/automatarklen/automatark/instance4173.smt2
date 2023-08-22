(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /\/images\/[a-zA-Z]\.php\?id\=[0-9]{2,3}(\.\d)?$/Ui
(assert (not (str.in_re X (re.++ (str.to_re "//images/") (re.union (re.range "a" "z") (re.range "A" "Z")) (str.to_re ".php?id=") ((_ re.loop 2 3) (re.range "0" "9")) (re.opt (re.++ (str.to_re ".") (re.range "0" "9"))) (str.to_re "/Ui\u{0a}")))))
; Host\x3Acdpnode=FILESIZE\x3E
(assert (str.in_re X (str.to_re "Host:cdpnode=FILESIZE>\u{13}\u{0a}")))
(assert (> (str.len X) 10))
(check-sat)
