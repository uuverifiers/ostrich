(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; www\x2Epcsentinelsoftware\x2Ecom
(assert (not (str.in_re X (str.to_re "www.pcsentinelsoftware.com\u{0a}"))))
; ^([0-9a-fA-F]){8}$
(assert (str.in_re X (re.++ ((_ re.loop 8 8) (re.union (re.range "0" "9") (re.range "a" "f") (re.range "A" "F"))) (str.to_re "\u{0a}"))))
; www\x2Eyok\x2Ecom\s+jupitersatellites\x2Ebiz.*User-Agent\x3Aclvompycem\u{2f}cen\.vcn
(assert (not (str.in_re X (re.++ (str.to_re "www.yok.com") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "jupitersatellites.biz") (re.* re.allchar) (str.to_re "User-Agent:clvompycem/cen.vcn\u{0a}")))))
; \x2Fcgi\x2Flogurl\.cgi\s+IDENTIFY.*max-www\x2Eu88\x2Ecn
(assert (not (str.in_re X (re.++ (str.to_re "/cgi/logurl.cgi") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "IDENTIFY") (re.* re.allchar) (str.to_re "max-www.u88.cn\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
