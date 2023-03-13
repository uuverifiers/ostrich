(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; Root\s+insert\s+haveFTUser-Agent\x3ADayspassword\x3B0\x3BIncorrectClientsConnected-Host\x3A\x2APORT3\x2A
(assert (str.in_re X (re.++ (str.to_re "Root") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "insert") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "haveFTUser-Agent:Dayspassword;0;IncorrectClientsConnected-Host:*PORT3*\u{0a}"))))
; User-Agent\u{3a}\s+www\x2Einternet-optimizer\x2Ecom
(assert (not (str.in_re X (re.++ (str.to_re "User-Agent:") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "www.internet-optimizer.com\u{0a}")))))
; /^\/index\.php\?[A-Za-z0-9_-]{15}=l3S/U
(assert (not (str.in_re X (re.++ (str.to_re "//index.php?") ((_ re.loop 15 15) (re.union (re.range "A" "Z") (re.range "a" "z") (re.range "0" "9") (str.to_re "_") (str.to_re "-"))) (str.to_re "=l3S/U\u{0a}")))))
(check-sat)
