(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; \x2FrssaboutinformationHost\x3A\x2Fezsbu=DISKHost\x3Aad\x2Emokead\x2Ecom
(assert (str.in_re X (str.to_re "/rssaboutinformationHost:/ezsbu=DISKHost:ad.mokead.com\u{0a}")))
; /\u{2f}\{\u{23}[^\u{2f}{}]+?\}(\.action)?\u{2f}?$/miU
(assert (not (str.in_re X (re.++ (str.to_re "//{#") (re.+ (re.union (str.to_re "/") (str.to_re "{") (str.to_re "}"))) (str.to_re "}") (re.opt (str.to_re ".action")) (re.opt (str.to_re "/")) (str.to_re "/miU\u{0a}")))))
; from\s+\x2Fdss\x2Fcc\.2_0_0\.[^\n\r]*uploadServer
(assert (not (str.in_re X (re.++ (str.to_re "from") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "/dss/cc.2_0_0.") (re.* (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}"))) (str.to_re "uploadServer\u{0a}")))))
; Agent\s+\x2Ftoolbar\x2Fico\x2F
(assert (str.in_re X (re.++ (str.to_re "Agent") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "/toolbar/ico/\u{0a}"))))
; SE\d{2}[ ]\d{4}[ ]\d{4}[ ]\d{4}[ ]\d{4}[ ]\d{4}|SE\d{22}
(assert (str.in_re X (re.++ (str.to_re "SE") (re.union (re.++ ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re " ") ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re " ") ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re " ") ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re " ") ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re " ") ((_ re.loop 4 4) (re.range "0" "9"))) (re.++ ((_ re.loop 22 22) (re.range "0" "9")) (str.to_re "\u{0a}"))))))
(assert (> (str.len X) 10))
(check-sat)
