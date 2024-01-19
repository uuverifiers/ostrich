(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^http://\w{0,3}.?youtube+\.\w{2,3}/watch\?v=[\w-]{11}
(assert (not (str.in_re X (re.++ (str.to_re "http://") ((_ re.loop 0 3) (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (re.opt re.allchar) (str.to_re "youtub") (re.+ (str.to_re "e")) (str.to_re ".") ((_ re.loop 2 3) (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "/watch?v=") ((_ re.loop 11 11) (re.union (str.to_re "-") (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "\u{0a}")))))
; Handyst=ClassStopperHost\x3ASpamBlockerUtility
(assert (str.in_re X (str.to_re "Handyst=ClassStopperHost:SpamBlockerUtility\u{0a}")))
(assert (> (str.len X) 10))
(check-sat)
