(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; Host\u{3a}.*UNSEEN\u{22}\s+Agentbody=\u{25}21\u{25}21\u{25}21Optix
(assert (not (str.in_re X (re.++ (str.to_re "Host:") (re.* re.allchar) (str.to_re "UNSEEN\u{22}") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "Agentbody=%21%21%21Optix\u{13}\u{0a}")))))
; User-Agent\x3A\w+data2\.activshopper\.comdll\x3F
(assert (not (str.in_re X (re.++ (str.to_re "User-Agent:") (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "data2.activshopper.comdll?\u{0a}")))))
; ^\d{2}\-(Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec|jan|feb|mar|apr|may|jun|jul|aug|sep|oct|nov|dec|JAN|FEB|MAR|APR|MAY|JUN|JUL|AUG|SEP|OCT|NOV|DEC)\-\d{4}$
(assert (str.in_re X (re.++ ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re "-") (re.union (str.to_re "Jan") (str.to_re "Feb") (str.to_re "Mar") (str.to_re "Apr") (str.to_re "May") (str.to_re "Jun") (str.to_re "Jul") (str.to_re "Aug") (str.to_re "Sep") (str.to_re "Oct") (str.to_re "Nov") (str.to_re "Dec") (str.to_re "jan") (str.to_re "feb") (str.to_re "mar") (str.to_re "apr") (str.to_re "may") (str.to_re "jun") (str.to_re "jul") (str.to_re "aug") (str.to_re "sep") (str.to_re "oct") (str.to_re "nov") (str.to_re "dec") (str.to_re "JAN") (str.to_re "FEB") (str.to_re "MAR") (str.to_re "APR") (str.to_re "MAY") (str.to_re "JUN") (str.to_re "JUL") (str.to_re "AUG") (str.to_re "SEP") (str.to_re "OCT") (str.to_re "NOV") (str.to_re "DEC")) (str.to_re "-") ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re "\u{0a}"))))
; (FR-?)?[0-9A-Z]{2}\ ?[0-9]{9}
(assert (not (str.in_re X (re.++ (re.opt (re.++ (str.to_re "FR") (re.opt (str.to_re "-")))) ((_ re.loop 2 2) (re.union (re.range "0" "9") (re.range "A" "Z"))) (re.opt (str.to_re " ")) ((_ re.loop 9 9) (re.range "0" "9")) (str.to_re "\u{0a}")))))
(check-sat)
