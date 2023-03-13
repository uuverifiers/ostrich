(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; [\(]{1,}[^)]*[)]{1,}
(assert (not (str.in_re X (re.++ (re.+ (str.to_re "(")) (re.* (re.comp (str.to_re ")"))) (re.+ (str.to_re ")")) (str.to_re "\u{0a}")))))
; HWAE[^\n\r]*Email[^\n\r]*User-Agent\x3AUser-Agent\u{3a}wowokayHost\x3A
(assert (str.in_re X (re.++ (str.to_re "HWAE") (re.* (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}"))) (str.to_re "Email") (re.* (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}"))) (str.to_re "User-Agent:User-Agent:wowokayHost:\u{0a}"))))
; tb\x2Efreeprod\x2Ecom\s+Web\.fcgiclvompycem\u{2f}cen\.vcn
(assert (not (str.in_re X (re.++ (str.to_re "tb.freeprod.com") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "Web.fcgiclvompycem/cen.vcn\u{0a}")))))
; (^\d{5}\x2D\d{3}$)
(assert (not (str.in_re X (re.++ (str.to_re "\u{0a}") ((_ re.loop 5 5) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 3 3) (re.range "0" "9"))))))
; e2give\.com.*Host\x3A.*Host\u{3a}
(assert (not (str.in_re X (re.++ (str.to_re "e2give.com") (re.* re.allchar) (str.to_re "Host:") (re.* re.allchar) (str.to_re "Host:\u{0a}")))))
(check-sat)
