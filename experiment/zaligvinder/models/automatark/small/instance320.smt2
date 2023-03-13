(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; [0-3]{1}[0-9]{1}(jan|JAN|feb|FEB|mar|MAR|apr|APR|may|MAY|jun|JUN|jul|JUL|aug|AUG|sep|SEP|oct|OCT|nov|NOV|dec|DEC){1}
(assert (not (str.in_re X (re.++ ((_ re.loop 1 1) (re.range "0" "3")) ((_ re.loop 1 1) (re.range "0" "9")) ((_ re.loop 1 1) (re.union (str.to_re "jan") (str.to_re "JAN") (str.to_re "feb") (str.to_re "FEB") (str.to_re "mar") (str.to_re "MAR") (str.to_re "apr") (str.to_re "APR") (str.to_re "may") (str.to_re "MAY") (str.to_re "jun") (str.to_re "JUN") (str.to_re "jul") (str.to_re "JUL") (str.to_re "aug") (str.to_re "AUG") (str.to_re "sep") (str.to_re "SEP") (str.to_re "oct") (str.to_re "OCT") (str.to_re "nov") (str.to_re "NOV") (str.to_re "dec") (str.to_re "DEC"))) (str.to_re "\u{0a}")))))
; ^\{[A-Fa-f\d]{8}-[A-Fa-f\d]{4}-[A-Fa-f0\d]{4}-[A-Fa-f\d]{4}-[A-Fa-f\d]{12}\}$
(assert (not (str.in_re X (re.++ (str.to_re "{") ((_ re.loop 8 8) (re.union (re.range "A" "F") (re.range "a" "f") (re.range "0" "9"))) (str.to_re "-") ((_ re.loop 4 4) (re.union (re.range "A" "F") (re.range "a" "f") (re.range "0" "9"))) (str.to_re "-") ((_ re.loop 4 4) (re.union (re.range "A" "F") (re.range "a" "f") (str.to_re "0") (re.range "0" "9"))) (str.to_re "-") ((_ re.loop 4 4) (re.union (re.range "A" "F") (re.range "a" "f") (re.range "0" "9"))) (str.to_re "-") ((_ re.loop 12 12) (re.union (re.range "A" "F") (re.range "a" "f") (re.range "0" "9"))) (str.to_re "}\u{0a}")))))
; updates\x5D\u{25}20\x5BPort_NETObserve
(assert (str.in_re X (str.to_re "updates]%20[Port_NETObserve\u{0a}")))
; (\$(([0-9]?)[a-zA-Z]+)([0-9]?))
(assert (not (str.in_re X (re.++ (str.to_re "\u{0a}$") (re.opt (re.range "0" "9")) (re.opt (re.range "0" "9")) (re.+ (re.union (re.range "a" "z") (re.range "A" "Z")))))))
(check-sat)
