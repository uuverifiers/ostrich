(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^([EV])?\d{3,3}(\.\d{1,2})?$
(assert (str.in_re X (re.++ (re.opt (re.union (str.to_re "E") (str.to_re "V"))) ((_ re.loop 3 3) (re.range "0" "9")) (re.opt (re.++ (str.to_re ".") ((_ re.loop 1 2) (re.range "0" "9")))) (str.to_re "\u{0a}"))))
; Port\x2Ebody=ocllceclbhs\u{2f}gthWeComputerLoggerHost\x3Agdvsotuqwsg\u{2f}dxt\.hd^User-Agent\x3A
(assert (str.in_re X (str.to_re "Port.body=ocllceclbhs/gthWeComputerLoggerHost:gdvsotuqwsg/dxt.hdUser-Agent:\u{0a}")))
; SecureNet.*\x2Fsearchfast\x2F
(assert (str.in_re X (re.++ (str.to_re "SecureNet") (re.* re.allchar) (str.to_re "/searchfast/\u{0a}"))))
; Host\u{3a}\dOVNUsertooffers\x2Ebullseye-network\x2Ecom
(assert (str.in_re X (re.++ (str.to_re "Host:") (re.range "0" "9") (str.to_re "OVNUsertooffers.bullseye-network.com\u{0a}"))))
; /\/feed\.dll\?pub_id=\d+?\&ua=/Ui
(assert (str.in_re X (re.++ (str.to_re "//feed.dll?pub_id=") (re.+ (re.range "0" "9")) (str.to_re "&ua=/Ui\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
