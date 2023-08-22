(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; \[([\w \.]+)\]\(([\w\.:\/ ]*)\)
(assert (not (str.in_re X (re.++ (str.to_re "[") (re.+ (re.union (str.to_re " ") (str.to_re ".") (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "](") (re.* (re.union (str.to_re ".") (str.to_re ":") (str.to_re "/") (str.to_re " ") (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re ")\u{0a}")))))
; NetTracker.*Theef2[^\n\r]*versionA-311Subject\u{3a}www\x2Epcsentinelsoftware\x2Ecom
(assert (not (str.in_re X (re.++ (str.to_re "NetTracker") (re.* re.allchar) (str.to_re "Theef2") (re.* (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}"))) (str.to_re "versionA-311Subject:www.pcsentinelsoftware.com\u{0a}")))))
; ^\$[+-]?([0-9]+|[0-9]{1,3}(,[0-9]{3})*)(\.[0-9]{1,2})?$
(assert (not (str.in_re X (re.++ (str.to_re "$") (re.opt (re.union (str.to_re "+") (str.to_re "-"))) (re.union (re.+ (re.range "0" "9")) (re.++ ((_ re.loop 1 3) (re.range "0" "9")) (re.* (re.++ (str.to_re ",") ((_ re.loop 3 3) (re.range "0" "9")))))) (re.opt (re.++ (str.to_re ".") ((_ re.loop 1 2) (re.range "0" "9")))) (str.to_re "\u{0a}")))))
; www\x2Epcsentinelsoftware\x2Ecom
(assert (str.in_re X (str.to_re "www.pcsentinelsoftware.com\u{0a}")))
(assert (> (str.len X) 10))
(check-sat)
