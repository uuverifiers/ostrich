(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^(([0-9])|([0-2][0-9])|([3][0-1]))\/(Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec)\/\d{4}$
(assert (not (str.in_re X (re.++ (re.union (re.range "0" "9") (re.++ (re.range "0" "2") (re.range "0" "9")) (re.++ (str.to_re "3") (re.range "0" "1"))) (str.to_re "/") (re.union (str.to_re "Jan") (str.to_re "Feb") (str.to_re "Mar") (str.to_re "Apr") (str.to_re "May") (str.to_re "Jun") (str.to_re "Jul") (str.to_re "Aug") (str.to_re "Sep") (str.to_re "Oct") (str.to_re "Nov") (str.to_re "Dec")) (str.to_re "/") ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re "\u{0a}")))))
; ^\\([^\\]+\\)*[^\/:*?"<>|]?$
(assert (not (str.in_re X (re.++ (str.to_re "\u{5c}") (re.* (re.++ (re.+ (re.comp (str.to_re "\u{5c}"))) (str.to_re "\u{5c}"))) (re.opt (re.union (str.to_re "/") (str.to_re ":") (str.to_re "*") (str.to_re "?") (str.to_re "\u{22}") (str.to_re "<") (str.to_re ">") (str.to_re "|"))) (str.to_re "\u{0a}")))))
; MicrosoftHost\x3ASubject\u{3a}namedDownloadUser-Agent\u{3a}
(assert (str.in_re X (str.to_re "MicrosoftHost:Subject:namedDownloadUser-Agent:\u{0a}")))
; ^(\d{1,8}|(\d{0,8}\.{1}\d{1,2}){1})$
(assert (not (str.in_re X (re.++ (re.union ((_ re.loop 1 8) (re.range "0" "9")) ((_ re.loop 1 1) (re.++ ((_ re.loop 0 8) (re.range "0" "9")) ((_ re.loop 1 1) (str.to_re ".")) ((_ re.loop 1 2) (re.range "0" "9"))))) (str.to_re "\u{0a}")))))
(check-sat)
