(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^[0-9]{4}((0[1-9])|(1[0-2]))$
(assert (str.in_re X (re.++ ((_ re.loop 4 4) (re.range "0" "9")) (re.union (re.++ (str.to_re "0") (re.range "1" "9")) (re.++ (str.to_re "1") (re.range "0" "2"))) (str.to_re "\u{0a}"))))
; HXLogOnly\w+areSubject\u{3a}\swww\.fast-finder\.comawbeta\.net-nucleus\.com
(assert (str.in_re X (re.++ (str.to_re "HXLogOnly") (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "areSubject:") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "www.fast-finder.comawbeta.net-nucleus.com\u{0a}"))))
; ^[A-Z][a-z]+(tz)?(man|berg)$
(assert (not (str.in_re X (re.++ (re.range "A" "Z") (re.+ (re.range "a" "z")) (re.opt (str.to_re "tz")) (re.union (str.to_re "man") (str.to_re "berg")) (str.to_re "\u{0a}")))))
; \.fcgi[^\n\r]*Host\x3A\s\x5D\u{25}20\x5BPort_NETObserveTM_SEARCH3
(assert (not (str.in_re X (re.++ (str.to_re ".fcgi") (re.* (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}"))) (str.to_re "Host:") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "]%20[Port_NETObserveTM_SEARCH3\u{0a}")))))
; \x2Fpagead\x2Fads\?waitingisDownload
(assert (str.in_re X (str.to_re "/pagead/ads?waitingisDownload\u{0a}")))
(assert (> (str.len X) 10))
(check-sat)
