(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^(4915[0-1]|491[0-4]\d|490\d\d|4[0-8]\d{3}|[1-3]\d{4}|[1-9]\d{0,3}|0)$
(assert (not (str.in_re X (re.++ (re.union (re.++ (str.to_re "4915") (re.range "0" "1")) (re.++ (str.to_re "491") (re.range "0" "4") (re.range "0" "9")) (re.++ (str.to_re "490") (re.range "0" "9") (re.range "0" "9")) (re.++ (str.to_re "4") (re.range "0" "8") ((_ re.loop 3 3) (re.range "0" "9"))) (re.++ (re.range "1" "3") ((_ re.loop 4 4) (re.range "0" "9"))) (re.++ (re.range "1" "9") ((_ re.loop 0 3) (re.range "0" "9"))) (str.to_re "0")) (str.to_re "\u{0a}")))))
; <[^>]*\n?.*=("|')?(.*\.jpg)("|')?.*\n?[^<]*>
(assert (not (str.in_re X (re.++ (str.to_re "<") (re.* (re.comp (str.to_re ">"))) (re.opt (str.to_re "\u{0a}")) (re.* re.allchar) (str.to_re "=") (re.opt (re.union (str.to_re "\u{22}") (str.to_re "'"))) (re.opt (re.union (str.to_re "\u{22}") (str.to_re "'"))) (re.* re.allchar) (re.opt (str.to_re "\u{0a}")) (re.* (re.comp (str.to_re "<"))) (str.to_re ">\u{0a}") (re.* re.allchar) (str.to_re ".jpg")))))
; NetTracker.*Theef2[^\n\r]*versionA-311Subject\u{3a}www\x2Epcsentinelsoftware\x2Ecom
(assert (str.in_re X (re.++ (str.to_re "NetTracker") (re.* re.allchar) (str.to_re "Theef2") (re.* (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}"))) (str.to_re "versionA-311Subject:www.pcsentinelsoftware.com\u{0a}"))))
; \u{22}Thewebsearch\.getmirar\.com
(assert (not (str.in_re X (str.to_re "\u{22}Thewebsearch.getmirar.com\u{0a}"))))
(check-sat)
