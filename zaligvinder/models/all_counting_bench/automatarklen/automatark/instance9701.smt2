(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; \b([0-1]?\d{1,2}|2[0-4]\d|25[0-5])(\.([0-1]?\d{1,2}|2[0-4]\d|25[0-5])){3}\b
(assert (not (str.in_re X (re.++ (re.union (re.++ (re.opt (re.range "0" "1")) ((_ re.loop 1 2) (re.range "0" "9"))) (re.++ (str.to_re "2") (re.range "0" "4") (re.range "0" "9")) (re.++ (str.to_re "25") (re.range "0" "5"))) ((_ re.loop 3 3) (re.++ (str.to_re ".") (re.union (re.++ (re.opt (re.range "0" "1")) ((_ re.loop 1 2) (re.range "0" "9"))) (re.++ (str.to_re "2") (re.range "0" "4") (re.range "0" "9")) (re.++ (str.to_re "25") (re.range "0" "5"))))) (str.to_re "\u{0a}")))))
; /\u{2e}jfif?([\?\u{5c}\u{2f}]|$)/smiU
(assert (str.in_re X (re.++ (str.to_re "/.jfi") (re.opt (str.to_re "f")) (re.union (str.to_re "?") (str.to_re "\u{5c}") (str.to_re "/")) (str.to_re "/smiU\u{0a}"))))
; upgrade\x2Eqsrch\x2Einfo[^\n\r]*dcww\x2Edmcast\x2Ecom
(assert (not (str.in_re X (re.++ (str.to_re "upgrade.qsrch.info") (re.* (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}"))) (str.to_re "dcww.dmcast.com\u{0a}")))))
; www\x2Elookster\x2Enetnotificationuuid=qisezhin\u{2f}iqor\.ym
(assert (str.in_re X (str.to_re "www.lookster.netnotification\u{13}uuid=qisezhin/iqor.ym\u{13}\u{0a}")))
(assert (> (str.len X) 10))
(check-sat)
