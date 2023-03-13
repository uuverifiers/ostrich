(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /^Host\u{3a}[^\u{0d}\u{0a}]+\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\u{3a}\d{1,5}\u{0d}?$/mi
(assert (not (str.in_re X (re.++ (str.to_re "/Host:") (re.+ (re.union (str.to_re "\u{0d}") (str.to_re "\u{0a}"))) ((_ re.loop 1 3) (re.range "0" "9")) (str.to_re ".") ((_ re.loop 1 3) (re.range "0" "9")) (str.to_re ".") ((_ re.loop 1 3) (re.range "0" "9")) (str.to_re ".") ((_ re.loop 1 3) (re.range "0" "9")) (str.to_re ":") ((_ re.loop 1 5) (re.range "0" "9")) (re.opt (str.to_re "\u{0d}")) (str.to_re "/mi\u{0a}")))))
; ^<\!\-\-(.*)+(\/){0,1}\-\->$
(assert (str.in_re X (re.++ (str.to_re "<!--") (re.+ (re.* re.allchar)) (re.opt (str.to_re "/")) (str.to_re "-->\u{0a}"))))
; ^\d[0-9]*[-/]\d[0-9]*$
(assert (not (str.in_re X (re.++ (re.range "0" "9") (re.* (re.range "0" "9")) (re.union (str.to_re "-") (str.to_re "/")) (re.range "0" "9") (re.* (re.range "0" "9")) (str.to_re "\u{0a}")))))
; /^\/load\.php\?spl=[^&]+&b=[^&]+&o=[^&]+&i=/U
(assert (str.in_re X (re.++ (str.to_re "//load.php?spl=") (re.+ (re.comp (str.to_re "&"))) (str.to_re "&b=") (re.+ (re.comp (str.to_re "&"))) (str.to_re "&o=") (re.+ (re.comp (str.to_re "&"))) (str.to_re "&i=/U\u{0a}"))))
; Host\x3AHost\x3AX-Mailer\u{3a}
(assert (not (str.in_re X (str.to_re "Host:Host:X-Mailer:\u{13}\u{0a}"))))
(check-sat)
