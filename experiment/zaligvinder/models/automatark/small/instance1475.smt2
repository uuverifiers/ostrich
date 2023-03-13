(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; logsFictionalReporterCookieUser-Agent\x3A
(assert (not (str.in_re X (str.to_re "logsFictionalReporterCookieUser-Agent:\u{0a}"))))
; ^(\d{3}-\d{2}-\d{4})|(\d{3}\d{2}\d{4})$
(assert (not (str.in_re X (re.union (re.++ ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 4 4) (re.range "0" "9"))) (re.++ (str.to_re "\u{0a}") ((_ re.loop 3 3) (re.range "0" "9")) ((_ re.loop 2 2) (re.range "0" "9")) ((_ re.loop 4 4) (re.range "0" "9")))))))
; Handyst=ClassStopperHost\x3ASpamBlockerUtility
(assert (str.in_re X (str.to_re "Handyst=ClassStopperHost:SpamBlockerUtility\u{0a}")))
; presentsearch\.netLocalHost\x3APORT\x3DWatchDogHost\x3A
(assert (not (str.in_re X (str.to_re "presentsearch.netLocalHost:PORT=WatchDogHost:\u{0a}"))))
(check-sat)
