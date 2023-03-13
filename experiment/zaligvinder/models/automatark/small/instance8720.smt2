(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^\d{5}$
(assert (not (str.in_re X (re.++ ((_ re.loop 5 5) (re.range "0" "9")) (str.to_re "\u{0a}")))))
; User-Agent\x3A\s+Robert
(assert (not (str.in_re X (re.++ (str.to_re "User-Agent:") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "Robert\u{0a}")))))
; Supreme\d+Host\x3A\d+yxegtd\u{2f}efcwgHost\x3ATPSystem
(assert (str.in_re X (re.++ (str.to_re "Supreme") (re.+ (re.range "0" "9")) (str.to_re "Host:") (re.+ (re.range "0" "9")) (str.to_re "yxegtd/efcwgHost:TPSystem\u{0a}"))))
; protocolhttp\x3A\x2F\x2Fwww\.searchinweb\.com\x2Fsearch\.php\?said=bar
(assert (str.in_re X (str.to_re "protocolhttp://www.searchinweb.com/search.php?said=bar\u{0a}")))
(check-sat)
