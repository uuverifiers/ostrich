(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; function.*WEBCAM-.*User-Agent\u{3a}
(assert (not (str.in_re X (re.++ (str.to_re "function") (re.* re.allchar) (str.to_re "WEBCAM-") (re.* re.allchar) (str.to_re "User-Agent:\u{0a}")))))
; \d{2,4}
(assert (not (str.in_re X (re.++ ((_ re.loop 2 4) (re.range "0" "9")) (str.to_re "\u{0a}")))))
; \r\nSTATUS\x3A\dHost\u{3a}Referer\x3AServerSubject\u{3a}
(assert (not (str.in_re X (re.++ (str.to_re "\u{0d}\u{0a}STATUS:") (re.range "0" "9") (str.to_re "Host:Referer:ServerSubject:\u{0a}")))))
; ^([0-1]?[0-9]|[2][0-3])[:|.]([0-5][0-9])$
(assert (not (str.in_re X (re.++ (re.union (re.++ (re.opt (re.range "0" "1")) (re.range "0" "9")) (re.++ (str.to_re "2") (re.range "0" "3"))) (re.union (str.to_re ":") (str.to_re "|") (str.to_re ".")) (str.to_re "\u{0a}") (re.range "0" "5") (re.range "0" "9")))))
; cojud\x2Edmcast\x2Ecom\sApofis\w+Referer\x3Awww\x2Emirarsearch\x2Ecom
(assert (not (str.in_re X (re.++ (str.to_re "cojud.dmcast.com") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "Apofis") (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "Referer:www.mirarsearch.com\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
