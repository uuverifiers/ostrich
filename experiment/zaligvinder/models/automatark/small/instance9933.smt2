(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^07[789]-\d{7}$
(assert (not (str.in_re X (re.++ (str.to_re "07") (re.union (str.to_re "7") (str.to_re "8") (str.to_re "9")) (str.to_re "-") ((_ re.loop 7 7) (re.range "0" "9")) (str.to_re "\u{0a}")))))
; Referer\u{3a}Host\u{3a}port\u{3a}activity
(assert (not (str.in_re X (str.to_re "Referer:Host:port:activity\u{0a}"))))
; /^http\u{7c}\d+\u{7c}\d+\x7C[a-z0-9]+\x2E[a-z]{2,3}\x7C[a-z0-9]+\x7C/
(assert (str.in_re X (re.++ (str.to_re "/http|") (re.+ (re.range "0" "9")) (str.to_re "|") (re.+ (re.range "0" "9")) (str.to_re "|") (re.+ (re.union (re.range "a" "z") (re.range "0" "9"))) (str.to_re ".") ((_ re.loop 2 3) (re.range "a" "z")) (str.to_re "|") (re.+ (re.union (re.range "a" "z") (re.range "0" "9"))) (str.to_re "|/\u{0a}"))))
; /filename=[^\n]*\u{2e}mppl/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".mppl/i\u{0a}")))))
; ^\d*\.?((25)|(50)|(5)|(75)|(0)|(00))?$
(assert (str.in_re X (re.++ (re.* (re.range "0" "9")) (re.opt (str.to_re ".")) (re.opt (re.union (str.to_re "25") (str.to_re "50") (str.to_re "5") (str.to_re "75") (str.to_re "0") (str.to_re "00"))) (str.to_re "\u{0a}"))))
(check-sat)
