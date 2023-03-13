(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; \b([2-9][p-z][a-h][2-9]{1,2}[a-z]+[p-z][2-9][p-z][2-9][p-z]|[a-z][a-z]+\d{2}[a-z]|[2-9][p-z]{2}[a-h][2-9]{1,2}[a-z]+[p-z][2-9]{3}[p-z]|\d{12}|[2-9][p-z][a-h][2-9][a-z0-9]+[p-z][2-9]{3}[p-z])\b
(assert (str.in_re X (re.++ (re.union (re.++ (re.range "2" "9") (re.range "p" "z") (re.range "a" "h") ((_ re.loop 1 2) (re.range "2" "9")) (re.+ (re.range "a" "z")) (re.range "p" "z") (re.range "2" "9") (re.range "p" "z") (re.range "2" "9") (re.range "p" "z")) (re.++ (re.range "a" "z") (re.+ (re.range "a" "z")) ((_ re.loop 2 2) (re.range "0" "9")) (re.range "a" "z")) (re.++ (re.range "2" "9") ((_ re.loop 2 2) (re.range "p" "z")) (re.range "a" "h") ((_ re.loop 1 2) (re.range "2" "9")) (re.+ (re.range "a" "z")) (re.range "p" "z") ((_ re.loop 3 3) (re.range "2" "9")) (re.range "p" "z")) ((_ re.loop 12 12) (re.range "0" "9")) (re.++ (re.range "2" "9") (re.range "p" "z") (re.range "a" "h") (re.range "2" "9") (re.+ (re.union (re.range "a" "z") (re.range "0" "9"))) (re.range "p" "z") ((_ re.loop 3 3) (re.range "2" "9")) (re.range "p" "z"))) (str.to_re "\u{0a}"))))
; WindowsFrom\x3A\x2FCU1\-extreme\x2Ebiz
(assert (not (str.in_re X (str.to_re "WindowsFrom:/CU1-extreme.biz\u{0a}"))))
; ^-?\d{1,3}\.(\d{3}\.)*\d{3},\d\d$|^-?\d{1,3},\d\d$
(assert (str.in_re X (re.union (re.++ (re.opt (str.to_re "-")) ((_ re.loop 1 3) (re.range "0" "9")) (str.to_re ".") (re.* (re.++ ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re "."))) ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re ",") (re.range "0" "9") (re.range "0" "9")) (re.++ (re.opt (str.to_re "-")) ((_ re.loop 1 3) (re.range "0" "9")) (str.to_re ",") (re.range "0" "9") (re.range "0" "9") (str.to_re "\u{0a}")))))
; Web-Mail\s+\x2Fcgi\x2Flogurl\.cgi.*SurveillanceHost\u{3a}
(assert (str.in_re X (re.++ (str.to_re "Web-Mail") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "/cgi/logurl.cgi") (re.* re.allchar) (str.to_re "Surveillance\u{13}Host:\u{0a}"))))
; /filename=[^\n]*\u{2e}avi/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".avi/i\u{0a}"))))
(check-sat)
