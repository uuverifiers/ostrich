(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^[0-3][0-9][0-1]\d{3}-\d{4}?
(assert (str.in_re X (re.++ (re.range "0" "3") (re.range "0" "9") (re.range "0" "1") ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re "\u{0a}"))))
; presentsearch\.netLocalHost\x3APORT\x3DWatchDogHost\x3A
(assert (str.in_re X (str.to_re "presentsearch.netLocalHost:PORT=WatchDogHost:\u{0a}")))
(assert (> (str.len X) 10))
(check-sat)
