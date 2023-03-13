(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; sponsor2\.ucmore\.comUser-Agent\x3AUser-Agent\x3A
(assert (not (str.in_re X (str.to_re "sponsor2.ucmore.comUser-Agent:User-Agent:\u{0a}"))))
; \x2Fcgi\x2Flogurl\.cgi\s+IDENTIFY.*max-www\x2Eu88\x2Ecn
(assert (not (str.in_re X (re.++ (str.to_re "/cgi/logurl.cgi") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "IDENTIFY") (re.* re.allchar) (str.to_re "max-www.u88.cn\u{0a}")))))
; /^\/[\w-]{48}$/U
(assert (not (str.in_re X (re.++ (str.to_re "//") ((_ re.loop 48 48) (re.union (str.to_re "-") (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "/U\u{0a}")))))
; User-Agent\x3AHost\u{3a}\u{22}The
(assert (str.in_re X (str.to_re "User-Agent:Host:\u{22}The\u{0a}")))
(check-sat)
