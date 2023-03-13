(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; \x2Ehtml.*cm.*www\x2Epeer2mail\x2EcomConnectedStubbyawbeta\.net-nucleus\.com
(assert (str.in_re X (re.++ (str.to_re ".html") (re.* re.allchar) (str.to_re "cm") (re.* re.allchar) (str.to_re "www.peer2mail.comConnectedStubbyawbeta.net-nucleus.com\u{0a}"))))
; ^[a-zA-Z_]{1}[a-zA-Z0-9_@$#]*$
(assert (str.in_re X (re.++ ((_ re.loop 1 1) (re.union (re.range "a" "z") (re.range "A" "Z") (str.to_re "_"))) (re.* (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re "_") (str.to_re "@") (str.to_re "$") (str.to_re "#"))) (str.to_re "\u{0a}"))))
; /^\d+O\d+\.jsp\?[a-z0-9\u{3d}\u{2b}\u{2f}]{20}/iR
(assert (not (str.in_re X (re.++ (str.to_re "/") (re.+ (re.range "0" "9")) (str.to_re "O") (re.+ (re.range "0" "9")) (str.to_re ".jsp?") ((_ re.loop 20 20) (re.union (re.range "a" "z") (re.range "0" "9") (str.to_re "=") (str.to_re "+") (str.to_re "/"))) (str.to_re "/iR\u{0a}")))))
; RXFilteredDmInf\x5EJMailYeah\!Online\u{25}21\u{25}21\u{25}21Reportsversion\x2Etxt
(assert (not (str.in_re X (str.to_re "RXFilteredDmInf^JMailYeah!Online%21%21%21Reportsversion.txt\u{0a}"))))
; clvompycem\u{2f}cen\.vcnHost\x3AUser-Agent\x3A\u{0d}\u{0a}
(assert (str.in_re X (str.to_re "clvompycem/cen.vcnHost:User-Agent:\u{0d}\u{0a}\u{0a}")))
(check-sat)
