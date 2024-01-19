(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; Everyware.*Email.*Host\x3Astepwww\x2Ekornputers\x2Ecom
(assert (not (str.in_re X (re.++ (str.to_re "Everyware") (re.* re.allchar) (str.to_re "Email") (re.* re.allchar) (str.to_re "Host:stepwww.kornputers.com\u{0a}")))))
; Port\x2E[^\n\r]*007\d+Logsdl\x2Eweb-nexus\x2Enet
(assert (not (str.in_re X (re.++ (str.to_re "Port.") (re.* (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}"))) (str.to_re "007") (re.+ (re.range "0" "9")) (str.to_re "Logsdl.web-nexus.net\u{0a}")))))
; M\x2Ezip\d+dll\x3F\s+CodeguruBrowserwww\x2Esogou\x2Ecom
(assert (not (str.in_re X (re.++ (str.to_re "M.zip") (re.+ (re.range "0" "9")) (str.to_re "dll?") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "CodeguruBrowserwww.sogou.com\u{0a}")))))
; /\u{3f}sv\u{3d}\d{1,3}\u{26}tq\u{3d}/smiU
(assert (str.in_re X (re.++ (str.to_re "/?sv=") ((_ re.loop 1 3) (re.range "0" "9")) (str.to_re "&tq=/smiU\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
