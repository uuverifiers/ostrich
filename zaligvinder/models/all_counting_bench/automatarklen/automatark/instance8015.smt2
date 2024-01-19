(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; \\$\\d+[.]?\\d*
(assert (str.in_re X (re.++ (str.to_re "\u{5c}\u{5c}") (re.+ (str.to_re "d")) (re.opt (str.to_re ".")) (str.to_re "\u{5c}") (re.* (str.to_re "d")) (str.to_re "\u{0a}"))))
; /^\/b\/(letr|req|opt|eve)\/[0-9a-fA-F]{24}$/U
(assert (str.in_re X (re.++ (str.to_re "//b/") (re.union (str.to_re "letr") (str.to_re "req") (str.to_re "opt") (str.to_re "eve")) (str.to_re "/") ((_ re.loop 24 24) (re.union (re.range "0" "9") (re.range "a" "f") (re.range "A" "F"))) (str.to_re "/U\u{0a}"))))
; \x2Easpxdata\.warezclient\.comWinCrashrunningUser-Agent\x3Awowokay
(assert (not (str.in_re X (str.to_re ".aspxdata.warezclient.comWinCrashrunningUser-Agent:wowokay\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
