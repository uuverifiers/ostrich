(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; Host\x3A\s+Host\s+Host\u{3a}InformationX-OSSproxy\u{3a}as\x2Estarware\x2Ecom
(assert (not (str.in_re X (re.++ (str.to_re "Host:") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "Host") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "Host:InformationX-OSSproxy:as.starware.com\u{0a}")))))
; OSSProxyZC-BridgeHost\x3AReferer\u{3a}FunWebProducts
(assert (not (str.in_re X (str.to_re "OSSProxyZC-BridgeHost:Referer:FunWebProducts\u{0a}"))))
; corep\x2Edmcast\x2Ecom\s+FunWebProducts\w+searchreslt\x7D\x7BSysuptime\x3ASubject\x3AHANDY
(assert (not (str.in_re X (re.++ (str.to_re "corep.dmcast.com") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "FunWebProducts") (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "searchreslt}{Sysuptime:Subject:HANDY\u{0a}")))))
; Port.*Pro.*www\u{2e}proventactics\u{2e}comwv=update\.cgidrivesDays
(assert (str.in_re X (re.++ (str.to_re "Port") (re.* re.allchar) (str.to_re "Pro") (re.* re.allchar) (str.to_re "www.proventactics.comwv=update.cgidrivesDays\u{0a}"))))
; ^(0\.|([1-9]([0-9]+)?)\.){3}(0|([1-9]([0-9]+)?)){1}$
(assert (not (str.in_re X (re.++ ((_ re.loop 3 3) (re.union (str.to_re "0.") (re.++ (str.to_re ".") (re.range "1" "9") (re.opt (re.+ (re.range "0" "9")))))) ((_ re.loop 1 1) (re.union (str.to_re "0") (re.++ (re.range "1" "9") (re.opt (re.+ (re.range "0" "9")))))) (str.to_re "\u{0a}")))))
(check-sat)
