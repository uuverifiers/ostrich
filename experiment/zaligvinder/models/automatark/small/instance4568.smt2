(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; NetTracker.*Theef2[^\n\r]*versionA-311Subject\u{3a}www\x2Epcsentinelsoftware\x2Ecom
(assert (str.in_re X (re.++ (str.to_re "NetTracker") (re.* re.allchar) (str.to_re "Theef2") (re.* (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}"))) (str.to_re "versionA-311Subject:www.pcsentinelsoftware.com\u{0a}"))))
; ^\({0,1}0(2|3|7|8)\){0,1}(\ |-){0,1}[0-9]{4}(\ |-){0,1}[0-9]{4}$
(assert (str.in_re X (re.++ (re.opt (str.to_re "(")) (str.to_re "0") (re.union (str.to_re "2") (str.to_re "3") (str.to_re "7") (str.to_re "8")) (re.opt (str.to_re ")")) (re.opt (re.union (str.to_re " ") (str.to_re "-"))) ((_ re.loop 4 4) (re.range "0" "9")) (re.opt (re.union (str.to_re " ") (str.to_re "-"))) ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re "\u{0a}"))))
; /\.makeMeasurement\s*\u{28}[^\u{3b}]+?Array/i
(assert (not (str.in_re X (re.++ (str.to_re "/.makeMeasurement") (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "(") (re.+ (re.comp (str.to_re ";"))) (str.to_re "Array/i\u{0a}")))))
(check-sat)
