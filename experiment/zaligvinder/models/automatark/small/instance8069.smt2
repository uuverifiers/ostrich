(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^(\d{3}|\d{4})[-](\d{5})$
(assert (str.in_re X (re.++ (re.union ((_ re.loop 3 3) (re.range "0" "9")) ((_ re.loop 4 4) (re.range "0" "9"))) (str.to_re "-") ((_ re.loop 5 5) (re.range "0" "9")) (str.to_re "\u{0a}"))))
; ^\$?(\d{1,3}(\,\d{3})*|(\d+))(\.\d{0,2})?$
(assert (not (str.in_re X (re.++ (re.opt (str.to_re "$")) (re.union (re.++ ((_ re.loop 1 3) (re.range "0" "9")) (re.* (re.++ (str.to_re ",") ((_ re.loop 3 3) (re.range "0" "9"))))) (re.+ (re.range "0" "9"))) (re.opt (re.++ (str.to_re ".") ((_ re.loop 0 2) (re.range "0" "9")))) (str.to_re "\u{0a}")))))
; \b[1-9]{1}[0-9]{1,5}-\d{2}-\d\b
(assert (not (str.in_re X (re.++ ((_ re.loop 1 1) (re.range "1" "9")) ((_ re.loop 1 5) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re "-") (re.range "0" "9") (str.to_re "\u{0a}")))))
; http\s+Host\x3A[^\n\r]*WinInet3Azopabora\x2Einfo\x2Fnotifier\x2FUser-Agent\x3A
(assert (not (str.in_re X (re.++ (str.to_re "http") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "Host:") (re.* (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}"))) (str.to_re "WinInet3Azopabora.info/notifier/User-Agent:\u{0a}")))))
(check-sat)
