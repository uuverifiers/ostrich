(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; replace(MobileNo,' ',''),'^(\+44|0044|0)(7)[4-9][0-9]{8}$'
(assert (str.in_re X (re.++ (str.to_re "replaceMobileNo,' ','','") (re.union (str.to_re "+44") (str.to_re "0044") (str.to_re "0")) (str.to_re "7") (re.range "4" "9") ((_ re.loop 8 8) (re.range "0" "9")) (str.to_re "'\u{0a}"))))
; ookflolfctm\u{2f}nmot\.fmu
(assert (str.in_re X (str.to_re "ookflolfctm/nmot.fmu\u{0a}")))
; www\.trackhits\.ccUser-Agent\x3Aiz=LOGSupremeResult
(assert (str.in_re X (str.to_re "www.trackhits.ccUser-Agent:iz=LOGSupremeResult\u{0a}")))
; MSNLOGOVNUsertooffers\x2Ebullseye-network\x2Ecom
(assert (str.in_re X (str.to_re "MSNLOGOVNUsertooffers.bullseye-network.com\u{0a}")))
(assert (> (str.len X) 10))
(check-sat)
