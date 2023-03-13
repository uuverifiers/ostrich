(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^[0-9]{5}$
(assert (not (str.in_re X (re.++ ((_ re.loop 5 5) (re.range "0" "9")) (str.to_re "\u{0a}")))))
; Referer\x3A.*notification.*qisezhin\u{2f}iqor\.ymspasServer\u{3a}
(assert (str.in_re X (re.++ (str.to_re "Referer:") (re.* re.allchar) (str.to_re "notification\u{13}") (re.* re.allchar) (str.to_re "qisezhin/iqor.ym\u{13}spasServer:\u{0a}"))))
; www\.trackhits\.ccUser-Agent\x3Aiz=LOGSupremeResult
(assert (str.in_re X (str.to_re "www.trackhits.ccUser-Agent:iz=LOGSupremeResult\u{0a}")))
; ^(\+27|27)?(\()?0?([7][1-9]|[8][2-4])(\))?( |-|\.|_)?(\d{3})( |-|\.|_)?(\d{4})
(assert (str.in_re X (re.++ (re.opt (re.union (str.to_re "+27") (str.to_re "27"))) (re.opt (str.to_re "(")) (re.opt (str.to_re "0")) (re.union (re.++ (str.to_re "7") (re.range "1" "9")) (re.++ (str.to_re "8") (re.range "2" "4"))) (re.opt (str.to_re ")")) (re.opt (re.union (str.to_re " ") (str.to_re "-") (str.to_re ".") (str.to_re "_"))) ((_ re.loop 3 3) (re.range "0" "9")) (re.opt (re.union (str.to_re " ") (str.to_re "-") (str.to_re ".") (str.to_re "_"))) ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re "\u{0a}"))))
(check-sat)
