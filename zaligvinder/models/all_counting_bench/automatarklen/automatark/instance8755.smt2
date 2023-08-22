(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /\/html\/license_[0-9A-F]{550,}\.html$/Ui
(assert (str.in_re X (re.++ (str.to_re "//html/license_.html/Ui\u{0a}") ((_ re.loop 550 550) (re.union (re.range "0" "9") (re.range "A" "F"))) (re.* (re.union (re.range "0" "9") (re.range "A" "F"))))))
; ^100$|^0$|^[1-9]{0,1}[0-9]{0,1}$|^[1-9]{0,1}[0-9]{0,1}\.[0-9]{1,3}$
(assert (str.in_re X (re.union (str.to_re "100") (str.to_re "0") (re.++ (re.opt (re.range "1" "9")) (re.opt (re.range "0" "9"))) (re.++ (re.opt (re.range "1" "9")) (re.opt (re.range "0" "9")) (str.to_re ".") ((_ re.loop 1 3) (re.range "0" "9")) (str.to_re "\u{0a}")))))
; dat\s+resultsmaster\x2Ecom.*Host\u{3a}.*SpyAgentRootHost\x3AAdToolsSubject\x3Ae2give\.com
(assert (str.in_re X (re.++ (str.to_re "dat") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "resultsmaster.com\u{13}") (re.* re.allchar) (str.to_re "Host:") (re.* re.allchar) (str.to_re "SpyAgentRootHost:AdToolsSubject:e2give.com\u{0a}"))))
; CUSTOM\swww\x2Elocators\x2Ecom\d+Seconds\-
(assert (not (str.in_re X (re.++ (str.to_re "CUSTOM") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "www.locators.com") (re.+ (re.range "0" "9")) (str.to_re "Seconds-\u{0a}")))))
; Subject\x3AHost\u{3a}Host\x3A000Filelogin_ok\x5EMiniCommand
(assert (not (str.in_re X (str.to_re "Subject:Host:Host:000Filelogin_ok^MiniCommand\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
