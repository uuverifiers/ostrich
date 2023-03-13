(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^0$|^[1-9][0-9]*$|^[1-9][0-9]{0,2}(,[0-9]{3})$
(assert (not (str.in_re X (re.union (str.to_re "0") (re.++ (re.range "1" "9") (re.* (re.range "0" "9"))) (re.++ (re.range "1" "9") ((_ re.loop 0 2) (re.range "0" "9")) (str.to_re "\u{0a},") ((_ re.loop 3 3) (re.range "0" "9")))))))
; ver\d+sports\w+whenu\x2Ecomwp-includes\x2Ffeed\x2Ephp\x3F
(assert (str.in_re X (re.++ (str.to_re "ver") (re.+ (re.range "0" "9")) (str.to_re "sports") (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "whenu.com\u{13}wp-includes/feed.php?\u{0a}"))))
; presentsearch\.netLocalHost\x3APORT\x3DWatchDogHost\x3A
(assert (str.in_re X (str.to_re "presentsearch.netLocalHost:PORT=WatchDogHost:\u{0a}")))
; ^\d*[0-9](\.\d?[0-9])?$
(assert (not (str.in_re X (re.++ (re.* (re.range "0" "9")) (re.range "0" "9") (re.opt (re.++ (str.to_re ".") (re.opt (re.range "0" "9")) (re.range "0" "9"))) (str.to_re "\u{0a}")))))
; ^[H][R][\-][0-9]{5}$
(assert (str.in_re X (re.++ (str.to_re "HR-") ((_ re.loop 5 5) (re.range "0" "9")) (str.to_re "\u{0a}"))))
(check-sat)
