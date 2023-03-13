(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; badurl\x2Egrandstreetinteractive\x2EcomFilteredHost\x3Ae2give\.com\x2Fnewsurfer4\x2F
(assert (not (str.in_re X (str.to_re "badurl.grandstreetinteractive.comFilteredHost:e2give.com/newsurfer4/\u{0a}"))))
; /^\/images2\/[0-9a-fA-F]{500,}/U
(assert (str.in_re X (re.++ (str.to_re "//images2//U\u{0a}") ((_ re.loop 500 500) (re.union (re.range "0" "9") (re.range "a" "f") (re.range "A" "F"))) (re.* (re.union (re.range "0" "9") (re.range "a" "f") (re.range "A" "F"))))))
; si=\s+ProAgentUI2Host\x3A00000www\x2Ezhongsou\x2Ecom
(assert (not (str.in_re X (re.++ (str.to_re "si=") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "ProAgentUI2Host:00000www.zhongsou.com\u{0a}")))))
; /ID3\u{03}\u{00}.{5}([TW][A-Z]{3}|COMM)/smi
(assert (str.in_re X (re.++ (str.to_re "/ID3\u{03}\u{00}") ((_ re.loop 5 5) re.allchar) (re.union (re.++ (re.union (str.to_re "T") (str.to_re "W")) ((_ re.loop 3 3) (re.range "A" "Z"))) (str.to_re "COMM")) (str.to_re "/smi\u{0a}"))))
(check-sat)
