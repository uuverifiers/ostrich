(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; welcome\s+Host\x3A\s+ThistoIpHost\x3Abadurl\x2Egrandstreetinteractive\x2Ecom
(assert (not (str.in_re X (re.++ (str.to_re "welcome") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "Host:") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "ThistoIpHost:badurl.grandstreetinteractive.com\u{0a}")))))
; Keylogger-Pro\s+isUser-Agent\x3A
(assert (str.in_re X (re.++ (str.to_re "Keylogger-Pro") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "isUser-Agent:\u{0a}"))))
; ^([0-1]?[0-9]{1}|2[0-3]{1}):([0-5]{1}[0-9]{1})$
(assert (not (str.in_re X (re.++ (re.union (re.++ (re.opt (re.range "0" "1")) ((_ re.loop 1 1) (re.range "0" "9"))) (re.++ (str.to_re "2") ((_ re.loop 1 1) (re.range "0" "3")))) (str.to_re ":\u{0a}") ((_ re.loop 1 1) (re.range "0" "5")) ((_ re.loop 1 1) (re.range "0" "9"))))))
; media\x2Edxcdirect\x2Ecom
(assert (str.in_re X (str.to_re "media.dxcdirect.com\u{0a}")))
; /^Host\x3A\s+.*jaiku\x2Ecom/smiH
(assert (str.in_re X (re.++ (str.to_re "/Host:") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.* re.allchar) (str.to_re "jaiku.com/smiH\u{0a}"))))
(check-sat)
