(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; www\u{2e}proventactics\u{2e}comKeyloggerExplorerfileserverSI\|Server\|www\x2Emyarmory\x2Ecom
(assert (str.in_re X (str.to_re "www.proventactics.comKeyloggerExplorerfileserverSI|Server|\u{13}www.myarmory.com\u{0a}")))
; ovplHost\x3AHost\x3ADownloadUser
(assert (not (str.in_re X (str.to_re "ovplHost:Host:DownloadUser\u{0a}"))))
; /\u{2e}avi([\?\u{5c}\u{2f}]|$)/smiU
(assert (str.in_re X (re.++ (str.to_re "/.avi") (re.union (str.to_re "?") (str.to_re "\u{5c}") (str.to_re "/")) (str.to_re "/smiU\u{0a}"))))
; ^([\w\d\-\.]+)@{1}(([\w\d\-]{1,67})|([\w\d\-]+\.[\w\d\-]{1,67}))\.(([a-zA-Z\d]{2,4})(\.[a-zA-Z\d]{2})?)$
(assert (not (str.in_re X (re.++ (re.+ (re.union (re.range "0" "9") (str.to_re "-") (str.to_re ".") (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) ((_ re.loop 1 1) (str.to_re "@")) (re.union ((_ re.loop 1 67) (re.union (re.range "0" "9") (str.to_re "-") (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (re.++ (re.+ (re.union (re.range "0" "9") (str.to_re "-") (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re ".") ((_ re.loop 1 67) (re.union (re.range "0" "9") (str.to_re "-") (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))))) (str.to_re ".\u{0a}") ((_ re.loop 2 4) (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9"))) (re.opt (re.++ (str.to_re ".") ((_ re.loop 2 2) (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9")))))))))
; /filename=[^\n]*\u{2e}motn/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".motn/i\u{0a}"))))
(check-sat)
