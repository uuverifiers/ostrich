(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; (^\d{2}\.\d{3}\.\d{3}\/\d{4}\-\d{2}$)
(assert (str.in_re X (re.++ (str.to_re "\u{0a}") ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re ".") ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re ".") ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re "/") ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 2 2) (re.range "0" "9")))))
; Handyst=ClassStopperHost\x3ASpamBlockerUtility
(assert (not (str.in_re X (str.to_re "Handyst=ClassStopperHost:SpamBlockerUtility\u{0a}"))))
; ^[1-9]{1}$|^[0-9]{1}[0-9]{1}[0-9]{1}[0-9]{1}$|^9999$
(assert (not (str.in_re X (re.union ((_ re.loop 1 1) (re.range "1" "9")) (re.++ ((_ re.loop 1 1) (re.range "0" "9")) ((_ re.loop 1 1) (re.range "0" "9")) ((_ re.loop 1 1) (re.range "0" "9")) ((_ re.loop 1 1) (re.range "0" "9"))) (str.to_re "9999\u{0a}")))))
; User-Agent\x3A.*community\w+\u{0d}\u{0a}subject=GhostVoice
(assert (not (str.in_re X (re.++ (str.to_re "User-Agent:") (re.* re.allchar) (str.to_re "community") (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "\u{0d}\u{0a}subject=GhostVoice\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
