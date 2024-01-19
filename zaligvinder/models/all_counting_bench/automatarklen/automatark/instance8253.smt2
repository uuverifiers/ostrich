(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; httphost[^\n\r]*www\x2Emaxifiles\x2Ecom
(assert (str.in_re X (re.++ (str.to_re "httphost") (re.* (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}"))) (str.to_re "www.maxifiles.com\u{0a}"))))
; /filename=[^\n]*\u{2e}rjs/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".rjs/i\u{0a}")))))
; ([a-zA-Z]:(\\w+)*\\[a-zA-Z0_9]+)?.xls
(assert (not (str.in_re X (re.++ (re.opt (re.++ (re.union (re.range "a" "z") (re.range "A" "Z")) (str.to_re ":") (re.* (re.++ (str.to_re "\u{5c}") (re.+ (str.to_re "w")))) (str.to_re "\u{5c}") (re.+ (re.union (re.range "a" "z") (re.range "A" "Z") (str.to_re "0") (str.to_re "_") (str.to_re "9"))))) re.allchar (str.to_re "xls\u{0a}")))))
; /^dir=[0-9A-F]{8}(-[0-9A-F]{4}){4}[0-9A-F]{8}&data=/Pi
(assert (not (str.in_re X (re.++ (str.to_re "/dir=") ((_ re.loop 8 8) (re.union (re.range "0" "9") (re.range "A" "F"))) ((_ re.loop 4 4) (re.++ (str.to_re "-") ((_ re.loop 4 4) (re.union (re.range "0" "9") (re.range "A" "F"))))) ((_ re.loop 8 8) (re.union (re.range "0" "9") (re.range "A" "F"))) (str.to_re "&data=/Pi\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
