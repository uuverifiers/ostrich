(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /\u{2f}\?[0-9a-f]{60,66}[\u{3b}\d]*$/U
(assert (not (str.in_re X (re.++ (str.to_re "//?") ((_ re.loop 60 66) (re.union (re.range "0" "9") (re.range "a" "f"))) (re.* (re.union (str.to_re ";") (re.range "0" "9"))) (str.to_re "/U\u{0a}")))))
; too[^\n\r]*User-Agent\x3A\sHost\x3A.*IP-WindowsAttachedPalas\x2Estarware\x2Ecom\x2Fdp\x2Fsearch\?x=
(assert (not (str.in_re X (re.++ (str.to_re "too") (re.* (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}"))) (str.to_re "User-Agent:") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "Host:") (re.* re.allchar) (str.to_re "IP-WindowsAttachedPalas.starware.com/dp/search?x=\u{0a}")))))
; zmnjgmomgbdz\u{2f}zzmw\.gzt\s+Reports\s+HostHost\u{3a}Host\x3AHost\x3AMyWebSearchSearchAssistant
(assert (not (str.in_re X (re.++ (str.to_re "zmnjgmomgbdz/zzmw.gzt") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "Reports") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "HostHost:Host:Host:MyWebSearchSearchAssistant\u{0a}")))))
; /\u{2e}search\u{2d}ms([\?\u{5c}\u{2f}]|$)/smiU
(assert (not (str.in_re X (re.++ (str.to_re "/.search-ms") (re.union (str.to_re "?") (str.to_re "\u{5c}") (str.to_re "/")) (str.to_re "/smiU\u{0a}")))))
; User-Agent\x3ASurveillancecomOnline
(assert (str.in_re X (str.to_re "User-Agent:Surveillance\u{13}comOnline\u{0a}")))
(assert (< 200 (str.len X)))
(check-sat)
