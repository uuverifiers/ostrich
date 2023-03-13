(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /^\/[a-f0-9]{32}\.eot$/U
(assert (str.in_re X (re.++ (str.to_re "//") ((_ re.loop 32 32) (re.union (re.range "a" "f") (re.range "0" "9"))) (str.to_re ".eot/U\u{0a}"))))
; AdTools\sdownloadfile\u{2e}org\w+com\x3E[^\n\r]*as\x2Estarware\x2EcomOS\x2FSSKCstech\x2Eweb-nexus\x2Enet
(assert (str.in_re X (re.++ (str.to_re "AdTools") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "downloadfile.org") (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "com>") (re.* (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}"))) (str.to_re "as.starware.comOS/SSKCstech.web-nexus.net\u{0a}"))))
; mPOPUser-Agent\x3AgotS\u{3a}Users\u{5c}PORT\x3DHXLogOnlyMGS-Internal-Web-Manager
(assert (str.in_re X (str.to_re "mPOPUser-Agent:gotS:Users\u{5c}PORT=HXLogOnlyMGS-Internal-Web-Manager\u{0a}")))
; /filename=[^\n]*\u{2e}mp4/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".mp4/i\u{0a}")))))
; ^((((0?[13578])|(1[02]))[\-]?((0?[1-9]|[0-2][0-9])|(3[01])))|(((0?[469])|(11))[\-]?((0?[1-9]|[0-2][0-9])|(30)))|(0?[2][\-]?(0?[1-9]|[0-2][0-9])))[\-]?\d{2}$
(assert (str.in_re X (re.++ (re.union (re.++ (re.union (re.++ (re.opt (str.to_re "0")) (re.union (str.to_re "1") (str.to_re "3") (str.to_re "5") (str.to_re "7") (str.to_re "8"))) (re.++ (str.to_re "1") (re.union (str.to_re "0") (str.to_re "2")))) (re.opt (str.to_re "-")) (re.union (re.++ (str.to_re "3") (re.union (str.to_re "0") (str.to_re "1"))) (re.++ (re.opt (str.to_re "0")) (re.range "1" "9")) (re.++ (re.range "0" "2") (re.range "0" "9")))) (re.++ (re.union (re.++ (re.opt (str.to_re "0")) (re.union (str.to_re "4") (str.to_re "6") (str.to_re "9"))) (str.to_re "11")) (re.opt (str.to_re "-")) (re.union (str.to_re "30") (re.++ (re.opt (str.to_re "0")) (re.range "1" "9")) (re.++ (re.range "0" "2") (re.range "0" "9")))) (re.++ (re.opt (str.to_re "0")) (str.to_re "2") (re.opt (str.to_re "-")) (re.union (re.++ (re.opt (str.to_re "0")) (re.range "1" "9")) (re.++ (re.range "0" "2") (re.range "0" "9"))))) (re.opt (str.to_re "-")) ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re "\u{0a}"))))
(check-sat)
