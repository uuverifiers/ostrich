(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^[0-3]{1}[0-9]{1}[ ]{1}(Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec|JAN|FEB|MAR|APR|MAY|JUN|JUL|AUG|SEP|OCT|NOV|DEC|jan|feb|mar|apr|may|jun|jul|aug|sep|oct|nov|dec){1}[ ]{1}[0-9]{2}$
(assert (not (str.in_re X (re.++ ((_ re.loop 1 1) (re.range "0" "3")) ((_ re.loop 1 1) (re.range "0" "9")) ((_ re.loop 1 1) (str.to_re " ")) ((_ re.loop 1 1) (re.union (str.to_re "Jan") (str.to_re "Feb") (str.to_re "Mar") (str.to_re "Apr") (str.to_re "May") (str.to_re "Jun") (str.to_re "Jul") (str.to_re "Aug") (str.to_re "Sep") (str.to_re "Oct") (str.to_re "Nov") (str.to_re "Dec") (str.to_re "JAN") (str.to_re "FEB") (str.to_re "MAR") (str.to_re "APR") (str.to_re "MAY") (str.to_re "JUN") (str.to_re "JUL") (str.to_re "AUG") (str.to_re "SEP") (str.to_re "OCT") (str.to_re "NOV") (str.to_re "DEC") (str.to_re "jan") (str.to_re "feb") (str.to_re "mar") (str.to_re "apr") (str.to_re "may") (str.to_re "jun") (str.to_re "jul") (str.to_re "aug") (str.to_re "sep") (str.to_re "oct") (str.to_re "nov") (str.to_re "dec"))) ((_ re.loop 1 1) (str.to_re " ")) ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re "\u{0a}")))))
; /\u{2e}mks([\?\u{5c}\u{2f}]|$)/smiU
(assert (not (str.in_re X (re.++ (str.to_re "/.mks") (re.union (str.to_re "?") (str.to_re "\u{5c}") (str.to_re "/")) (str.to_re "/smiU\u{0a}")))))
; ^\{([1-9]{1}|[1-9]{1}[0-9]{1,}){1}\}\{([1-9]{1}|[1-9]{1}[0-9]{1,}){1}\}(.*)$
(assert (str.in_re X (re.++ (str.to_re "{") ((_ re.loop 1 1) (re.union ((_ re.loop 1 1) (re.range "1" "9")) (re.++ ((_ re.loop 1 1) (re.range "1" "9")) (re.+ (re.range "0" "9"))))) (str.to_re "}{") ((_ re.loop 1 1) (re.union ((_ re.loop 1 1) (re.range "1" "9")) (re.++ ((_ re.loop 1 1) (re.range "1" "9")) (re.+ (re.range "0" "9"))))) (str.to_re "}") (re.* re.allchar) (str.to_re "\u{0a}"))))
; ([\r\n ]*//[^\r\n]*)+
(assert (str.in_re X (re.++ (re.+ (re.++ (re.* (re.union (str.to_re "\u{0d}") (str.to_re "\u{0a}") (str.to_re " "))) (str.to_re "//") (re.* (re.union (str.to_re "\u{0d}") (str.to_re "\u{0a}"))))) (str.to_re "\u{0a}"))))
; (\d{5})[\.\-\+ ]?(\d{4})?
(assert (str.in_re X (re.++ ((_ re.loop 5 5) (re.range "0" "9")) (re.opt (re.union (str.to_re ".") (str.to_re "-") (str.to_re "+") (str.to_re " "))) (re.opt ((_ re.loop 4 4) (re.range "0" "9"))) (str.to_re "\u{0a}"))))
(check-sat)
