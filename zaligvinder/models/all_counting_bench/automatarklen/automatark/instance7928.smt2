(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; \x2Ehtml.*cm.*www\x2Epeer2mail\x2EcomConnectedStubbyawbeta\.net-nucleus\.com
(assert (not (str.in_re X (re.++ (str.to_re ".html") (re.* re.allchar) (str.to_re "cm") (re.* re.allchar) (str.to_re "www.peer2mail.comConnectedStubbyawbeta.net-nucleus.com\u{0a}")))))
; stats\u{2e}drivecleaner\u{2e}com\sPARSERInformationurl=Host\x3A
(assert (not (str.in_re X (re.++ (str.to_re "stats.drivecleaner.com\u{13}") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "PARSERInformationurl=Host:\u{0a}")))))
; clvompycem\u{2f}cen\.vcnHost\x3AUser-Agent\x3A\u{0d}\u{0a}
(assert (str.in_re X (str.to_re "clvompycem/cen.vcnHost:User-Agent:\u{0d}\u{0a}\u{0a}")))
; /gate\u{2e}php\u{3f}id=[a-z]{15}/U
(assert (str.in_re X (re.++ (str.to_re "/gate.php?id=") ((_ re.loop 15 15) (re.range "a" "z")) (str.to_re "/U\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
